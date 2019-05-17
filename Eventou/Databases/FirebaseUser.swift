//
//  FirebaseUser.swift
//  Jardim Apura
//
//  Created by Bruno Rocca on 08/10/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Firebase
import UIKit

class FirebaseUser{
    var ref: DatabaseReference!{
        return Database.database().reference().child("users")
    }

    // Retorna o usuário pelo seu ID
    func getUserById(id: String ,completion: @escaping(_ user: User?) -> Void){
        let userReference = ref.child(id)
        
        userReference.observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? NSDictionary else{
                completion(nil)
                return
            }
            
            
            let result = value as! [String : Any]
            
            let completeName = result["completeName"] as! String
            let photoURL = result["photoURL"] as! String
            let email = result["email"] as! String
            let userBlackList = result["userBlackList"] as? [String : Any] ?? [:]
            let eventBlackList = result["eventBlackList"] as? [String : Any] ?? [:]
            
            let user = User(id: id, completeName: completeName, photoURL: photoURL, email: email)
            
            //pegando todos os usuários bloqueados
            for userBlocked in userBlackList{
                user.userBlackList.append(userBlocked.key)
            }
            //pegando todos os eventos bloqueados
            for eventBlocked in eventBlackList{
                user.eventBlackList.append(eventBlocked.key)
            }
            
            completion(user)
        })
    }
    
    // Atualiza o usuário no Firebase. Se o usuário ainda não existe, é criado.
    func saveUser(user: User){
        
        let userReference = ref.child(user.id)
        
        let newUserData = [
            "id" : user.id,
            "name" : user.name,
            "lastName" : user.lastName,
            "completeName" : user.completeName,
            "photoURL" : user.photoURL,
            "email" : user.email,
            "tags" : user.tags,
            "createdEvents" : user.createdEvents
        ] as [String : Any]
        
        userReference.setValue(newUserData)

        //re-adicionando lista de usuários e eventos bloqueados
        
        for blockedUser in user.userBlackList{
            let userBlackListReference = userReference.child("userBlackList").child(blockedUser)
            let newUserBlock = [
                "id" : blockedUser
            ]
            userBlackListReference.setValue(newUserBlock)
        }
        for blockedEvent in user.eventBlackList{
            let eventBlackListReference = userReference.child("eventBlackList").child(blockedEvent)
            let newEventBlock = [
                "id" : blockedEvent
            ]
            eventBlackListReference.setValue(newEventBlock)
        }
    }
    
    func blockUser(userId: String){
        let currentUser = (Auth.auth().currentUser?.uid)!
        let userReference = ref.child(currentUser).child("userBlackList").child(userId)
        
        let newUserBlock = [
            "id" : userId
        ]
        userReference.setValue(newUserBlock)
    }
    func blockEvent(eventId: String){
        let currentUser = (Auth.auth().currentUser?.uid)!
        let userReference = ref.child(currentUser).child("eventBlackList").child(eventId)
        
        let newEventBlock = [
            "id" : eventId
        ]
        userReference.setValue(newEventBlock)
    }
}
