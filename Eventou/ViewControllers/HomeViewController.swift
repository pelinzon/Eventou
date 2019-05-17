//
//  HomeViewController.swift
//  Jardim Apura
//
//  Created by Lucas Pelinzon on 08/10/18.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Variables
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    fileprivate var heightDictionary: [Int : CGFloat] = [:]
    
    public var events: [Event] = []
    private var firebaseEvent: FirebaseEvent = FirebaseEvent()
    private var savedEventList: [Event] = []
    private var eventCoreData: EventCoreData = EventCoreData()
    private var userCoreData = UserCoreData()
    var refreshControl: UIRefreshControl!
    var rotated = false
    
    //MARK: - Outlets
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlBackground: UIView!
    
    //MARK: - Actions

    // Acionada quando o índice do Segmented Control se altera
    @IBAction func indexChanged(_ sender: Any) {
        reloadMainTable()
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        // Garante que essa view esteja sempre na frente de todas as outras
        segmentedControlBackground.layer.zPosition = .greatestFiniteMagnitude
        
        // Define os atributos da Navigation Bar
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.08235294118, green: 0.8156862745, blue: 0.8117647059, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        
        showActivityIndicatory()
        getEvents()
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.08235294118, green: 0.8156862745, blue: 0.8117647059, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        homeTableView.addSubview(refreshControl)
        
        // Adiciona os elementos personalizados na Navigation Bar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Perfil", style: .done, target: self, action: #selector(profileClicked))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEventClicked))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        homeTableView.reloadData()
        
        print("BROTOU")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    //MARK: - Custom Methods
    @objc private func addEventClicked() {
        if(Auth.isLoggedIn()){
            performSegue(withIdentifier: "showNewEvent", sender: self)
        }else{
            performSegue(withIdentifier: "showFeedToLogin", sender: self)
        }
    }
    
    @objc func refresh(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            getEvents()
            break
        case 1:
            getTaggedEvents()
            break
        case 2:
            getSavedEvents()
        default:
            break
        }
        refreshControl.endRefreshing()
    }
    
    func reloadMainTable() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            events.removeAll()
            homeTableView.reloadData()
            showActivityIndicatory()
            getEvents()
            break
        case 1:
            //TODO: Fetch from Firebase only events that match the user's preferred tags.
            events.removeAll()
            homeTableView.reloadData()
            showActivityIndicatory()
            getTaggedEvents()
            break
        case 2:
            events.removeAll()
            homeTableView.reloadData()
            getSavedEvents()
        default:
            break
        }
    }
    
    public func getEvents() {
        if(Auth.isLoggedIn()){
            firebaseEvent.getAllEventsLogged(completion: { firebaseEvents in
                self.events = firebaseEvents
                self.sortEvents()
                
                self.homeTableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
            
            homeTableView.reloadData()
        }
        else{
            firebaseEvent.getAllEvents(completion: { firebaseEvents in
                self.events = firebaseEvents
                self.sortEvents()
                
                self.homeTableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
            
            homeTableView.reloadData()
        }
    }
    private func getTaggedEvents(){
        firebaseEvent.getTaggedEvents(completion: {taggedEvents in
            self.events = taggedEvents
            self.sortEvents()
            
            self.homeTableView.reloadData()
            self.activityIndicator.stopAnimating()
        })
        self.homeTableView.reloadData()
    }
    private func getSavedEvents() {
        events = eventCoreData.getSavedEvents()
        self.sortEvents()
        
        homeTableView.reloadData()
    }
    
    private func sortEvents(){
        events.sort(by: {
            $0.dateFormat! > $1.dateFormat!
            
        })
    }
    
 
    @objc private func profileClicked() {
        performSegue(withIdentifier: "showProfile", sender: self)
    }
    
    func showActivityIndicatory() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor(red: 21/255, green: 208/255, blue: 207/255, alpha: 1)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    //MARK: - Default Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showEvent"){
            let rowClicked = sender as! Int
            let event = events[rowClicked]
            let nextViewController = segue.destination as! EventViewController
            
            //Se o evento está sendo pego do CoreData
            if(events[rowClicked].idCreator == ""){
                event.creatorName = events[rowClicked].creatorName
            }
            
            nextViewController.event = event
        }
        if(segue.identifier == "showFeedToLogin"){
            let nextViewControler = segue.destination as! LoginViewController
            nextViewControler.segueBefore = segue.identifier!
        }
    }
    
    //MARK: - Necessary Table View Methods
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        heightDictionary[indexPath.row] = cell.frame.size.height
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = heightDictionary[indexPath.row]
        return height ?? UITableView.automaticDimension
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
        performSegue(withIdentifier: "showEvent", sender: indexPath.section)
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
        cell.eventHours.text = String(format: "Das %02d:%02d as %02d:%02d", displayStartHour, displayStartMinute, displayEndHour, displayEndMinute)
        cell.eventDay.text = "\(displayDay)"
        cell.eventMonth.text = "\(displayMonthName)"
        cell.idEventClicked = events[indexPath.section].id
        cell.event = events[indexPath.section]
        
        cell.eventImage.image = events[indexPath.section].image

        
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
