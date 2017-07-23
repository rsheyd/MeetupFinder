//
//  Event.swift
//  MeetupFinder
//
//  Created by Roman Sheydvasser on 7/21/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Event {
    let groupName: String
    let eventName: String
    let eventDescription: String
    let rsvpCount: Int
    let rsvpLimit: Int
    let longitude: Double
    let latitude: Double
    let time: Double
    let link: String
    
    init(groupName: String, eventName: String, eventDescription: String, rsvpCount: Int, rsvpLimit: Int, lat: Double, lon: Double, time: Double, link: String) {
        self.groupName = groupName
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.rsvpCount = rsvpCount
        self.rsvpLimit = rsvpLimit
        self.latitude = lat
        self.longitude = lon
        self.time = time
        self.link = link
    }
}
