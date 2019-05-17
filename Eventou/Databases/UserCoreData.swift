//
//  CoreDataEvent.swift
//  Jardim Apura
//
//  Created by Bruno Rocca on 08/10/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UserCoreData {
    var tags: [UserCore] = []
    var saved: [UserCore] = []
    
    var context : NSManagedObjectContext  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var userCore: UserCore!
    
    func addTagsToUser(tags: [String]) {
        if userCore == nil {
            //userCore = UserCore(context: context)
        }
        for tag in tags {
            userCore = UserCore(context: context)
            userCore.tags = tag
            do {
                try context.save()
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadTags() -> [String]{
        let fetchRequest : NSFetchRequest<UserCore> = UserCore.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "tags", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var tagsString: [String] = []
        
        do {
            tags = try context.fetch(fetchRequest)
            
            for tag in tags{
                let tagString = tag.tags!
                tagsString.append(tagString)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return tagsString
    }
    func deleteAllTags(){
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCore")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("ERROR: To delete all tags")
        }
    }
}
