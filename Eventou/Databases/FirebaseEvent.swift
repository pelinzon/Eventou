//
//  FirebaseEvent.swift
//  Jardim Apura
//
//  Created by Bruno Rocca on 08/10/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Firebase
import FirebaseAuth

class FirebaseEvent{
    var ref: DatabaseReference!{
        return Database.database().reference().child("events")
    }
    
    // Busca o evento no Firebase pelo ID
    func getEvent(id: String ,completion: @escaping (_ event: Event?) -> Void){
        var event: Event?
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let rawData = value as! [String : Any]
            
            for key in rawData.keys{
                if(key == id){
                    let result = rawData[id] as! [String : Any]
                    
                    let title = result["title"] as! String
                    let idCreator = result["idCreator"] as! String
                    let description = result["description"] as! String
                    let date = result["date"] as! String
                    let location = result["location"] as! String
                    let alreadyFinished = result["alreadyFinished"] as! Bool
                    let startingTime = result["startingTime"] as! String
                    let endingTime = result["endingTime"] as! String
                    
                    // Busca a imagem no Storage
                    let firebaseStorage = FirebaseStorage()
                    var eventImage = UIImage()
                    
                    firebaseStorage.downloadPhoto(path: id, completion: {image in
                        eventImage = image
                    })
                    
                    event = Event(title: title, image: eventImage, idCreator: idCreator, description: description, date: date, location: location, startingTime: startingTime, endingTime: endingTime, tags: ["sport","art"])
                    event?.alreadyFinished = alreadyFinished
                    event?.id = id
                    
                    completion(event)
                }
            }
        })
    }
    
    // Adiciona o evento no Firebase
    func addEvent(event: Event){
        let eventReference = ref.childByAutoId()
        
        let newEventData = [
            "title" : event.title,
            "idCreator" : event.idCreator,
            "description" : event.description,
            "date" : event.date,
            "location" : event.location,
            "alreadyFinished" : event.alreadyFinished,
            "startingTime" : event.startingTime,
            "endingTime" : event.endingTime,
            "tags" : event.tags,
            "place" : event.location ?? "Sem local",
            "link" : event.link ?? "Sem Link"
            ] as [String : Any]
        
        eventReference.setValue(newEventData)
        
        let path = eventReference.description()
        let name = cutPath(path: path)
        let firebaseStorage = FirebaseStorage()
        firebaseStorage.uploadPhoto(path: name, photo: event.image)
    }
    
    private func cutPath(path: String) -> String{
        let index = path.index(path.endIndex, offsetBy: -20)
        return String(path.suffix(from: index))
    }
    
    private func getTotalEvents(rawData : [String : Any]) -> Int{
        
        return rawData.count
    }
    
    // Retorna todos os eventos que ainda não acabaram
    func getAllEvents(completion: @escaping (_ events : [Event]) -> Void){
        var events: [Event] = []
        
        ref.observeSingleEvent(of: .value, with: {(snapshots) in
            let values = snapshots.value as? NSDictionary
            
            guard let rawData = values as? [String : Any] else {
                completion(events)
                return
            }
            
            for key in rawData.keys{
                let result = rawData[key] as! [String : Any]
                
                // Busca a imagem no Storage
                let firebaseStorage = FirebaseStorage()
                var eventImage = UIImage()
                
                firebaseStorage.downloadPhoto(path: key, completion: {image in
                    eventImage = image
                    
                    let event = Event(key: key,  rawData: result)
                    event.image = eventImage
                    
                    events.append(event)
                    
                    // Verifica se todos os eventos já foram retornados
                    if(rawData.count == events.count){
                        completion(events)
                    }
                })
            }
        })
    }
    func getAllEventsLogged(completion: @escaping (_ events : [Event]) -> Void){
        let currentUser = Auth.auth().currentUser
        var events: [Event] = []
        let firebaseUser = FirebaseUser()
    
        
        firebaseUser.getUserById(id: (currentUser?.uid)!) { (userWrapped) in
            let user = userWrapped!
            self.ref.observeSingleEvent(of: .value, with: {(snapshots) in
                let values = snapshots.value as? NSDictionary
                
                guard var rawData = values as? [String : Any] else {
                    completion(events)
                    return
                }
                
                //Busca quantos eventos no total, excluindo bloqueados
                for key in rawData.keys{
                    let result = rawData[key] as! [String : Any]
                    let idCreator = result["idCreator"] as! String
                    let idEvent = key
                    
                    for blockedUser in user.userBlackList{
                        if(blockedUser == idCreator){
                            rawData.removeValue(forKey: key)
                        }
                    }
                    for blockedEvent in user.eventBlackList{
                        if(blockedEvent == idEvent){
                            rawData.removeValue(forKey: key)
                        }
                    }
                }
                
                for key in rawData.keys{
                    let result = rawData[key] as! [String : Any]
                    
                    // Busca a imagem no Storage
                    let firebaseStorage = FirebaseStorage()
                    var eventImage = UIImage()
                    
                    firebaseStorage.downloadPhoto(path: key, completion: {image in
                        eventImage = image
                        
                        let event = Event(key: key,  rawData: result)
                        event.image = eventImage
                        
                        events.append(event)
                        
                        // Verifica se todos os eventos já foram retornados
                        if(rawData.count == events.count){
                            completion(events)
                        }
                    })
                }
            })
        }
    }
    
    // TODO: - Fetch only events created by one user.
    func getAllEventsFromUser(completion: @escaping (_ events : [Event]) -> Void){
        var events: [Event] = []
        let idCurrentUser = Auth.auth().currentUser?.uid

        ref.observeSingleEvent(of: .value, with: {(snapshots) in
            let values = snapshots.value as? NSDictionary
            
            guard let rawData = values as? [String : Any] else {
                completion(events)
                return
            }
            
            var counter = 0
            for key in rawData.keys{
                let resultCounter = rawData[key] as! [String : Any]
                let idCreatorCounter = resultCounter["idCreator"] as! String
                
                if(idCreatorCounter == idCurrentUser){
                    counter += 1
                }
            }
            if(counter == 0){
                completion(events)
            }
            
            for key in rawData.keys{
                let result = rawData[key] as! [String : Any]
                
                let event = Event(key: key,  rawData: result)
                
                var skip = true
                if (event.idCreator == idCurrentUser){
                    skip = false
                }
                
                if(skip == false){
                    // Busca a imagem no Storage
                    let firebaseStorage = FirebaseStorage()
                    var eventImage = UIImage()
                    
                    firebaseStorage.downloadPhoto(path: key, completion: {image in
                        eventImage = image
                        
                        event.image = eventImage
                        
                        events.append(event)

                        // Verifica se todos os eventos já foram retornados
                        if(counter == events.count){
                            completion(events)
                        }
                    })
                }
            }
        })
    }
    
    // Retorna somente eventos taggeados que ainda não acabaram
    func getTaggedEvents(completion: @escaping (_ events : [Event]) -> Void){
        var events: [Event] = []
        let currentUser = Auth.auth().currentUser
        let firebaseUser = FirebaseUser()
        
        firebaseUser.getUserById(id: currentUser?.uid ?? "nil") {user in
            self.ref.observeSingleEvent(of: .value, with: {(snapshots) in
                let values = snapshots.value as? NSDictionary
                
                guard var rawData = values as? [String : Any] else {
                    completion(events)
                    return
                }
                
                //Verificando préviamente a quantidade de eventos que estão incluidos dentro da tag do usuário
                let userCoreData = UserCoreData()
                let userTags = userCoreData.loadTags()
                
                for key in rawData.keys{
                    let resultCounter = rawData[key] as! [String : Any]
                    let tags = resultCounter["tags"] as! [String]
                    let intersect = tags.filter(userTags.contains)
                    
                    if(intersect.count == 0){   //se não tiver nenhuma tag em comum
                        rawData.removeValue(forKey: key)
                    }
                }
                //Verificando se o evento/criador do evento não foi bloqueado
                if(Auth.isLoggedIn()){
                    for key in rawData.keys{
                        let result = rawData[key] as! [String : Any]
                        let idCreator = result["idCreator"] as! String
                        let idEvent = key
                        
                        for blockedUser in (user?.userBlackList)!{
                            if(blockedUser == idCreator){
                                rawData.removeValue(forKey: key)
                                break
                            }
                        }
                        for blockedEvent in (user?.eventBlackList)!{
                            if(blockedEvent == idEvent){
                                rawData.removeValue(forKey: key)
                                break
                            }
                        }
                        
                        
                    }
                }
                
                //Se não tiver eventos com a tag do usuário
                if(rawData.count == 0){
                    completion(events)
                }
                
                for key in rawData.keys{
                    let result = rawData[key] as! [String : Any]
                    
                    // Busca a imagem no Storage
                    let firebaseStorage = FirebaseStorage()
                    var eventImage = UIImage()
                    
                    firebaseStorage.downloadPhoto(path: key, completion: {image in
                        eventImage = image
                        
                        let event = Event(key: key,  rawData: result)
                        event.image = eventImage
                        
                        //Adiciona o evento na lista, se este tiver uma das tags do usuário
                        for userTag in userTags{
                            if(event.tags.contains(userTag)){
                                events.append(event)
                                break
                            }
                        }
                        // Verifica se todos os eventos já foram retornados
                        if(rawData.count == events.count){
                            completion(events)
                        }
                    })
                }
            })
        }
    }
}

