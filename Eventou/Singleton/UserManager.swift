//
//  UserManager.swift
//  Jardim Apura
//
//  Created by Bruno Rocca on 09/12/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Foundation
import Firebase

class UserManager{
    private static var user: User?
    private static var group = DispatchGroup()
    
    class func shared() -> User?{
        return user
    }
}
