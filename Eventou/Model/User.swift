//
//  User.swift
//  Jardim Apura
//
//  Created by Lucas Pelinzon on 08/10/18.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Foundation
import UIKit

class User {
    var id: String
    var name: String
    var lastName: String
    var completeName: String
    var photoURL: String
    var email: String
    var tags: [String]
    var createdEvents: [Event]
    var userBlackList: [String]
    var eventBlackList: [String]
    
    init(id: String, completeName: String, photoURL: String, email: String) {
        self.id = id
        
        self.name = ""
        self.lastName = ""
        self.completeName = completeName
        
        self.photoURL = photoURL
        self.email = email
        
        self.tags = []
        self.createdEvents = []
        self.userBlackList = []
        self.eventBlackList = []
        
        self.name = getFirstName(name: completeName)
        self.lastName = getLastName(name: completeName)
    }
    
    private func getLastName(name: String) -> String{
        let allNames = name.components(separatedBy: " ")
        return allNames[allNames.count - 1]
    }
    private func getFirstName(name: String) -> String{
        let allNames = name.components(separatedBy: " ")
        return allNames[0]
    }
}
