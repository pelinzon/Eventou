//
//  ProfileViewController.swift
//  Jardim Apura
//
//  Created by Bruno Rocca on 08/10/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol SegueHandler: class {
    func segueToNext(identifier: String)
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SegueHandler {

    //MARK: - Variables
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var back: UIButton!
    var logoutOrLogin: UIButton!
    private var events: [Event] = []
    private var firebaseEvent: FirebaseEvent = FirebaseEvent()
    var refreshControl: UIRefreshControl!
    
    //MARK: - Outlets
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var myEventsTableView: UITableView!
    @IBOutlet weak var userBackgroundView: UIView!
    @IBOutlet weak var tableContainerView: UIView!
    
    //MARK: - Actions
    @IBAction func unwindToProfile(segue:UIStoryboardSegue) { }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileInfo()
        
        // begin debug

        showActivityIndicatory()
        
        firebaseEvent.getAllEventsFromUser(completion: { firebaseEvents in
            self.events = firebaseEvents
            self.myEventsTableView.reloadData()
            self.activityIndicator.stopAnimating()
        })
        
        myEventsTableView.reloadData()
        
        // end debug
        
        // Garante que essa view esteja sempre na frente de todas as outras.
        tableContainerView.layer.zPosition = .greatestFiniteMagnitude
        
        myEventsTableView.delegate = self
        myEventsTableView.dataSource = self
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.08235294118, green: 0.8156862745, blue: 0.8117647059, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        myEventsTableView.addSubview(refreshControl)
        
        // Define o gradiente da view utilizada como background para as informações do usuário
        var gl:CAGradientLayer!
        let colorTop = UIColor(red: 21.0 / 255.0, green: 208.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.0 / 255.0, green: 174.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0).cgColor
        
        gl = CAGradientLayer()
        gl.colors = [colorTop, colorBottom]
        gl.locations = [0.0, 1.0]
        
        userBackgroundView.backgroundColor = UIColor.clear
        let backgroundLayer = gl
        backgroundLayer?.frame = CGRect(x: userBackgroundView.frame.minX, y: userBackgroundView.frame.minY, width: view.frame.width, height: userBackgroundView.frame.height)
        userBackgroundView.layer.insertSublayer(backgroundLayer!, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setProfileInfo()
    }
    
    // Restaura o comportamento padrão da Navigation Bar
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    //MARK: - Custom Methods
    
    func segueToNext(identifier: String) {
        self.performSegue(withIdentifier: "showTags", sender: self)
    }
    
    @objc func refresh(_ sender: Any) {
        //TODO: - getEvents()
        refreshControl.endRefreshing()
    }
    
    @objc func loginTapped(){
        self.performSegue(withIdentifier: "showLogin", sender: self)
    }
    
    @objc func logoutTapped(){
        let alert = UIAlertController(title: nil, message:
            "Você tem certeza que deseja sair?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel,handler: nil))
        alert.addAction(UIAlertAction(title: "Sair", style: UIAlertAction.Style.destructive, handler: { action in
            try! Auth.auth().signOut()
            self.setProfileInfo()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicatory() {
        activityIndicator.center = CGPoint(x: view.frame.size.width / 2, y: 441)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor(red: 21/255, green: 208/255, blue: 207/255, alpha: 1)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    // TODO: - Pegar somente eventos que o usuário atual criou
    // private func getEvents() {
    // }
    
    private func setProfileInfo(){
        let currentUser = Auth.auth().currentUser
        
        if(Auth.isLoggedIn()){
            profileName.text = currentUser?.displayName
            let urlPhoto = currentUser?.photoURL?.absoluteString
            
            if(urlPhoto != nil){
                profilePicture.imageFromURL(urlString: urlPhoto!)
            }else{
                profilePicture.image = UIImage(named: "defaultUserTest")
            }

            //arredondando bordas da imagem
            profilePicture.layer.masksToBounds = false
            profilePicture.layer.cornerRadius = profilePicture.frame.height/2
            profilePicture.clipsToBounds = true
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sair", style: .done, target: self, action: #selector(logoutTapped))
        }
        else{
            profileName.text = "Name"
            profilePicture.image = UIImage(named: "defaultUserTest")
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Entrar", style: .done, target: self, action: #selector(loginTapped))
        }
        // Define as propriedades da foto de perfil do usuário
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
    }
    
    //MARK: - Default Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMyEvent" {
            let rowClicked = sender as! Int
            let event = events[rowClicked]
            let nextViewController = segue.destination as! EventViewController
            nextViewController.event = event
        }
        
        if segue.identifier == "EmbedTable" {
            let dvc = segue.destination as! MyTagsViewController
            dvc.delegate = self
        }
        
    }
    
    //MARK: - Necessary Table View Methods
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Eventos Criados"
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMyEvent", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Obtendo data pela string no formato ISO
        let ISODateFormat = ISO8601DateFormatter()
        let calendar = Calendar.current
        
        
        let startDate = ISODateFormat.date(from: events[indexPath.section].startingTime)
        let endDate = ISODateFormat.date(from: events[indexPath.section].endingTime)
        
        let displayDate = calendar.getDisplayDate(startDate: startDate!, endDate: endDate!)
        
        //Obtendo a hora, dia e mês que começa e termina o evento
        let displayStartMinute = calendar.component(.minute, from: startDate!)
        let displayStartHour = calendar.component(.hour, from: startDate!)
        let displayEndHour = calendar.component(.hour, from: endDate!)
        let displayEndMinute = calendar.component(.minute, from: endDate!)
        let displayDay = calendar.component(.day, from: displayDate)
        let displayMonth = calendar.component(.month, from: displayDate)
        let displayMonthName = calendar.getMonthName(month: displayMonth)
        
        //Colocando informações na célula
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as! CustomCellEvent
        cell.eventTitle.text = events[indexPath.section].title
        cell.eventHours.text = "Das \(displayStartHour):\(displayStartMinute) as \(displayEndHour):\(displayEndMinute)"
        cell.eventDay.text = "\(displayDay)"
        cell.eventMonth.text = "\(displayMonthName)"
        cell.eventImage.image = events[indexPath.section].image
        cell.idEventClicked = events[indexPath.section].id
        cell.event = events[indexPath.section]
        
        let eventCoreData = EventCoreData()
        let savedEvents = eventCoreData.getSavedEvents()
        
        //Looping referente para saber se este evento já foi favoritado ou não
        for event in savedEvents{
            if (events[indexPath.section].id == event.id){
                cell.setEventFavoriteIcon.image = UIImage(named: "frame_00027")
                return cell
            }
        }
        cell.setEventFavoriteIcon.image = UIImage(named: "frame_00001")
        return cell
    }
}
