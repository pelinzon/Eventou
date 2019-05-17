//
//  EventCoreData.swift
//  Jardim Apura
//
//  Created by Michelle Kamijo on 22/10/18.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class EventCoreData {

    var eventCore : EventCore!
    var context : NSManagedObjectContext  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    func getSavedEvents() -> [Event]{
        var savedEventList: [Event] = []
        var eventCore : [EventCore] = []
        
        let fetchRequest : NSFetchRequest<EventCore> = EventCore.fetchRequest()
        do {
            eventCore = try context.fetch(fetchRequest)
            
        } catch {
            print(error.localizedDescription)
        }
        
        for event in eventCore {
            let eventImage: UIImage
            if(event.imageEvent != nil){
                eventImage = UIImage(data: event.imageEvent!)!
            }else{
                eventImage = UIImage(named: "teste")!
            }
            
            
            let eventModel = Event(title: event.title!,
                                   image: eventImage, idCreator: "",
                                   description: event.descriptionEvent!,
                                   date: event.startingDate!,
                                   location: event.location!,
                                   startingTime: event.startingDate!,
                                   endingTime: event.endingDate!,
                                   tags: event.tags ?? [])
            eventModel.id = event.id!
            eventModel.creatorName = event.nameCreator
            eventModel.location = event.location ?? "Sem Local"
            eventModel.link = event.link ?? "Sem link"
            
            let calendar = Calendar.current
            let ISODateFormatter = ISO8601DateFormatter()
            eventModel.dateFormat = calendar.getDisplayDate(startDate: ISODateFormatter.date(from: eventModel.startingTime)!, endDate: ISODateFormatter.date(from: eventModel.endingTime)!)
            savedEventList.append(eventModel)
        }
        return savedEventList
    }
    
    func saveEvent(event: Event) {
        eventCore = EventCore(context: context)
        
        eventCore.title = event.title
        eventCore.id = event.id
        eventCore.startingDate = event.startingTime
        eventCore.alreadyFinished = event.alreadyFinished
        eventCore.location = event.location
        eventCore.endingDate = event.endingTime
        eventCore.descriptionEvent = event.description
        eventCore.imageCreator = "defaultUserTest"
        eventCore.tags = event.tags
        let eventImage = event.image
        let eventImageData = eventImage?.jpegData(compressionQuality: 1)

        eventCore.imageEvent = eventImageData
        
        //Obtendo o nome e imagem do criador
        let firebaseUser = FirebaseUser()
        firebaseUser.getUserById(id: event.idCreator, completion: {userWrapped in
            let user = userWrapped!
            self.eventCore.nameCreator = user.completeName
            self.eventCore.imageCreator = user.photoURL
            
            do {
                try self.context.save()
            }catch {
                print(error.localizedDescription)
            }
        })
    }
    
    func deleteSavedEvent(id: String){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventCore")
        deleteFetch.predicate = NSPredicate(format: "id == %@", id)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
            try context.execute(deleteRequest)
            try context.save()
        }
        catch{
            print("ERROR: To delete event")
        }
        
    }
    func deleteAllSavedEvents(){
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventCore")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("ERROR: To delete all events")
        }
    }
    

}

