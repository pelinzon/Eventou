//
//  Event.swift
//  Jardim Apura
//
//  Created by Lucas Pelinzon on 08/10/18.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Foundation
import UIKit

class Event {
    var id: String = ""
    var title: String
    var image: UIImage!
    var idCreator: String
    var creatorName: String?
    var creatorImage: String?
    var description: String
    var place: String?
    var link: String?
    var date: String
    var dateFormat: Date?
    var startingTime: String
    var endingTime: String
    var location: String
    var alreadyFinished: Bool = false
    var tags: [String] = []
    
    init(title: String, image: UIImage, idCreator: String, description: String, date: String, location: String, startingTime: String, endingTime: String, tags: [String]) {
        self.title = title
        self.image = image
        self.idCreator = idCreator
        self.description = description
        self.date = date
        self.startingTime = startingTime
        self.endingTime = endingTime
        self.location = location
        self.tags = tags
    }
    
    init(key: String, rawData: [String : Any]) {
        self.id = key
        self.title = rawData["title"] as! String
        self.idCreator = rawData["idCreator"] as! String
        self.description = rawData["description"] as! String
        self.date = rawData["date"] as! String
        self.location = rawData["location"] as! String
        self.link = (rawData["link"] as! String)
        self.alreadyFinished = rawData["alreadyFinished"] as! Bool
        self.startingTime = rawData["startingTime"] as! String
        self.endingTime = rawData["endingTime"] as! String
        self.tags = rawData["tags"] as! [String]
        
        let calendar = Calendar.current
        let ISODateFormatter = ISO8601DateFormatter()
        self.dateFormat = calendar.getDisplayDate(startDate: ISODateFormatter.date(from: self.startingTime)!, endDate: ISODateFormatter.date(from: self.endingTime)!)
    }
}
