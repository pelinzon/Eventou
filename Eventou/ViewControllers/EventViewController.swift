//
//  EventViewController.swift
//  Jardim Apura
//
//  Created by Lucas Pelinzon on 08/10/18.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return event.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagCollectionViewCell
        cell.tagLabel.text = event.tags[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagLength = 24 + (event.tags[indexPath.row].count * 9)
        return CGSize(width: tagLength, height: 30)
    }
    
    
    // COLLECTION VIEW TEMPORARY - END
    
    
    //MARK: - Variables
    var event: Event!
    var eventCreator: User!
    let firebaseUser = FirebaseUser()
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventBackgroundView: UIView!
    @IBOutlet weak var dateBackgroundView: UIView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var eventDay: UILabel!
    @IBOutlet weak var eventMonth: UILabel!
    @IBOutlet weak var eventHour: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventPlace: UILabel!
    @IBOutlet weak var eventLink: UILabel!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var tagsLabel: UILabel!
    
    //MARK: - Actions
    @IBAction func flagEventClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Denunciar Conteúdo", message: "Caso esse evento seja ofensivo ou inadequado, você pode denunciá-lo. \n \n Se você acredita que o criador esteja violando as regras em múltiplos eventos, por favor denuncie-o. \n \n Ocultaremos o conteúdo para você e sua denúncia será avaliada por nossa equipe.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Denunciar Evento", comment: ""), style: .destructive, handler: { _ in
            self.firebaseUser.blockEvent(eventId: self.event.id)
            self.performSegue(withIdentifier: "unwindToHome", sender: self)
            NSLog("Evento foi denunciado.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Denunciar Usuário", comment: ""), style: .destructive, handler: { _ in
            self.firebaseUser.blockUser(userId: self.event.idCreator)
            self.performSegue(withIdentifier: "unwindToHome", sender: self)
            NSLog("Usuário foi denunciado.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancelar", comment: ""), style: .cancel, handler: { _ in
            NSLog("Denúncia cancelada.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func hideButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Ocultar Conteúdo", message: "Caso não deseje mais ver esse evento pois seu conteúdo não é de seu interesse, você pode ocultá-lo. \n \n Se você não possui interesse em quaisquer eventos desse criador, você pode ocultar todos os seus eventos atuais e futuros. \n \n Essa operação somente oculta o conteúdo para você, e não para os outros usuários.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ocultar Evento", comment: ""), style: .destructive, handler: { _ in
            self.firebaseUser.blockEvent(eventId: self.event.id)
            self.performSegue(withIdentifier: "unwindToHome", sender: self)
            NSLog("Evento foi ocultado.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ocultar Usuário", comment: ""), style: .destructive, handler: { _ in
            self.firebaseUser.blockUser(userId: self.event.idCreator)
            self.performSegue(withIdentifier: "unwindToHome", sender: self)
            NSLog("Eventos do usuário foram ocultados.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancelar", comment: ""), style: .cancel, handler: { _ in
            NSLog("Ação cancelada.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.size.height + 300)
        
        eventBackgroundView.layer.cornerRadius = 7
        dateBackgroundView.layer.cornerRadius = 7
        
        eventInfoUpdate()
        creatorInfoUpdate()
    }
    
    //MARK: - Custom Methods
    private func creatorInfoUpdate(){
        let id = event.idCreator
        let firebaseUser = FirebaseUser()
        
        //Se o evento não foi puxado do CoreData
        if(id != ""){
            firebaseUser.getUserById(id: id, completion: {userWrapped in
                let user = userWrapped!
                self.userName.text = user.completeName
                self.userImage.imageFromURL(urlString: user.photoURL)
            })
        }else{
            self.userName.text = event.creatorName
        }
        
        // Define as propriedades da foto de perfil do usuário
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
    }

    private func eventInfoUpdate(){
        let ISOFormatter = ISO8601DateFormatter()
        let calendar = Calendar.current
        
        let startDate = ISOFormatter.date(from: event.startingTime)
        let endDate = ISOFormatter.date(from: event.endingTime)
        let postDate = ISOFormatter.date(from: event.date)
        
        let startDay = calendar.component(.day, from: startDate!)
        let startHour = calendar.component(.hour, from: startDate!)
        let startMinute = calendar.component(.minute, from: startDate!)
        let endHour = calendar.component(.hour, from: endDate!)
        let endMinute = calendar.component(.minute, from: endDate!)
        
        let eventMonthNumber = calendar.component(.month, from: startDate!)
        let eventMonthName = calendar.getMonthName(month: eventMonthNumber)
        
        let postDay = calendar.component(.day, from: postDate!)
        let postMonth = calendar.component(.month, from: postDate!)
        let postYear = calendar.component(.year, from: postDate!)
        
        
        eventImage.image = event.image
        eventTitle.text = event.title
        eventDescription.text = event.description
        eventPlace.text = event.location
        eventLink.text = event.link
        creationDate.text = String(format: "%02d/%02d/%02d", postDay, postMonth, postYear)
        eventDay.text = String(format: "%02d", startDay)
        eventDay.sizeToFit()
        eventHour.text = String(format: "%02d:%02d as %02d:%02d", startHour, startMinute, endHour, endMinute)
        eventMonth.text = eventMonthName
        
        event.tags.sort()
        tagsCollectionView.reloadData()
    }
    
    func eventTagsUpdate(){
        let tagsCount = event.tags.count

        //expandindo o background pro tamanho necessário
        for constraint in eventBackgroundView.constraints{
            if(constraint.identifier == "tagsToEventBack"){
                let scaleAux = CGFloat(Double(tagsCount)/2.0)
                var scale = ceil(scaleAux) - 1
                
                if(scale < 0){scale = 0}
                
                constraint.constant += CGFloat(38 * (scale))
                print("É ELE")
            }
        }
        
        
        //criando as tags/botões
        for i in 0..<tagsCount{
            let button = UIButton()
            let backgroundColor = UIColor(red: 237/255, green: 217/255, blue: 0/255, alpha: 1)

            let textColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

            //definindo o botão
            button.translatesAutoresizingMaskIntoConstraints = false
            button.frame = CGRect(x: 114, y: 294, width: 135, height: 31)
            button.backgroundColor = backgroundColor
            button.setTitle(event.tags[i], for: .normal)
            button.titleLabel?.textColor = textColor
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            button.layer.cornerRadius = 16

            eventBackgroundView.addSubview(button)
            
            //verificando se a tag fica na parte direita ou esquerda
            var leftAnchorConstant : CGFloat = 0
            var rightAnchorConstant : CGFloat = 0
            if(i % 2 == 0){
                leftAnchorConstant = 28
                rightAnchorConstant = 200
            }else{
                leftAnchorConstant = 200
                rightAnchorConstant = 28
            }
            let rightAnchor = button.superview?.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: rightAnchorConstant)
            let leftAnchor = button.leadingAnchor.constraint(equalTo: (button.superview?.leadingAnchor)!, constant: leftAnchorConstant)
            
            //definindo a altura que as tags ficarão
            
            
            let bottomAnchorConstant = CGFloat(14 + 38 * (((tagsCount) - i)/2))
            let topAnchorConstant = CGFloat(40 + 38 * (i/2))
            let bottomAnchor = button.superview?.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: bottomAnchorConstant)
            let topAnchor = button.topAnchor.constraint(equalTo: eventLink.bottomAnchor, constant: topAnchorConstant)
            
            topAnchor.priority = UILayoutPriority(900)
            bottomAnchor!.priority = UILayoutPriority(900)
            
            //criando constraints de height e width
            let widthConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 131)
            let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 31)
            
            //ativando constraints
            button.addConstraints([widthConstraint, heightConstraint])
            topAnchor.isActive = true
            bottomAnchor?.isActive = true
            leftAnchor.isActive = true
            rightAnchor?.isActive = true
        }
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        let eventCoreData = EventCoreData()
        let savedEvents = eventCoreData.getSavedEvents()
        
        //Testando se o evento já estava salvo
        if(savedEvents.contains(where: {$0.id == event.id})){
            _ = navigationController?.popViewController(animated: true)

        }else{  //se não esta salvo
            eventCoreData.saveEvent(event: event)

            _ = navigationController?.popViewController(animated: true)
        }
    }
}
