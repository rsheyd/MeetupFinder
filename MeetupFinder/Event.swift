//
//  Event.swift
//  MeetupFinder
//
//  Created by Roman Sheydvasser on 7/21/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class Event {
    let id: String
    let name: String
    var description: String?
    let groupName: String
    var groupPhotoUrl: String?
    var groupPhoto: UIImage?
    let category: String
    var rsvpCount: Int?
    var rsvpLimit: Int?
    var longitude: Double?
    var latitude: Double?
    let time: Double
    let link: String
    var distanceFromMe: Double?
    var myDateTime: String?
    
    init(id: String, name: String, groupName: String, category: String, time: Double, link: String) {
        self.id = id
        self.name = name
        self.groupName = groupName
        self.category = category
        self.time = time
        self.link = link
    }
    
    init(id: String, name: String, description: String, groupName: String, groupPhotoUrl: String, groupPhoto: UIImage, category: String, rsvpCount: Int, rsvpLimit: Int, lat: Double, lon: Double, time: Double, link: String) {
        self.id = id
        self.name = name
        self.description = description
        self.groupName = groupName
        self.groupPhotoUrl = groupPhotoUrl
        self.groupPhoto = groupPhoto
        self.category = category
        self.rsvpCount = rsvpCount
        self.rsvpLimit = rsvpLimit
        self.latitude = lat
        self.longitude = lon
        self.time = time
        self.link = link
    }
    
    init() {
        self.id = ""
        self.name = ""
        self.description = ""
        self.groupName = ""
        self.groupPhotoUrl = ""
        self.groupPhoto = UIImage()
        self.category = ""
        self.rsvpCount = 0
        self.rsvpLimit = 0
        self.latitude = 0
        self.longitude = 0
        self.time = 0
        self.link = ""
    }
    
    func toAnyObject() -> [String:Any] {
        return [
            "id" : id,
            "name" : name,
            "description" : description ?? "" ,
            "groupName" : groupName,
            "groupPhotoUrl" : groupPhotoUrl ?? "" ,
            "category" : category,
            "rsvpCount" : rsvpCount ?? 0,
            "rsvpLimit" : rsvpLimit ?? 0,
            "latitude" : latitude ?? 0,
            "longitude" : longitude ?? 0,
            "time" : time,
            "link" : link
        ]
    }
}
