//
//  MeetupToFirebase.swift
//  MeetupFinder
//
//  Created by Roman Sheydvasser on 8/25/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import Firebase
import CoreLocation

extension MeetupClient {
    func saveEventToFirebase(_ event: Event) {
        let newEventRef = eventsRef.child(event.id)
        newEventRef.setValue(event.toAnyObject())
    }
    
    func cacheEventsToFirebase(_ cacheId: String, _ events: [Event]) {
        let cacheIdRef = cachedEventsRef.child(cacheId)
        var eventIds: [String] = []
        for event in events {
            eventIds.append(event.id)
        }
        cacheIdRef.setValue(["events":eventIds, "date":Date().timeIntervalSince1970])
    }
    
    func convertLocationToId(_ lat: Double, _ long: Double) -> String? {
        let stringLat = shortenCoordinateToString(lat)
        let stringLong = shortenCoordinateToString(long)
        let id = "\(stringLat)\(stringLong)"
        print("Cache ID: \(id)")
        return id
    }
    
    func shortenCoordinateToString(_ coord: Double) -> String {
        var stringCoord = ""
        let shortCoord = Int(round(100*coord))
        if shortCoord < 0 {
            stringCoord = "n\(abs(shortCoord))"
        } else {
            stringCoord = "p\(shortCoord)"
        }
        return stringCoord
    }
    
    func checkForCachedEvents(_ cacheId: String, onComplete: @escaping (_ cacheExists: Bool)->Void) {
        let cacheIdRef = cachedEventsRef.child(cacheId)
        cacheIdRef.observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? NSDictionary,
                let cacheDateInt = value["date"] as? Double,
                Date().timeIntervalSince(Date(timeIntervalSince1970: cacheDateInt)) < 30 {
                print("Cache found and still recent. Using cache.")
                onComplete(true)
            } else {
                print("Cache too old or no cache found. Downloading events from meetup.")
                onComplete(false)
            }
        }) { error in
            print(error.localizedDescription)
            onComplete(false)
        }
    }
    
    func downloadCachedEvents(_ cacheId: String, onComplete: @escaping ()->Void) {
        print("downloading cached events")
        let cacheIdRef = cachedEventsRef.child(cacheId)
        cacheIdRef.observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? NSDictionary,
                let events = value["events"] as? [String] {
                self.loadEventsFromFirebase(events) {
                    onComplete()
                }
            }
        })
    }
    
    func loadEventsFromFirebase(_ events: [String], onComplete: @escaping ()->Void) {
        self.allEvents.removeAll()
        self.openEvents.removeAll()

        for eventId in events {
            let eventRef = eventsRef.child(eventId)
            if eventId == events.last {
                eventRef.observeSingleEvent(of: .value, with: { snapshot in
                    print("getting last event")
                    if let value = snapshot.value as? [String:Any?],
                        let event = self.makeEventFromFirebase(value) {
                        if event.rsvpLimit != event.rsvpCount {
                            self.openEvents.append(event)
                        }
                        self.allEvents.append(event)
                    }
                    onComplete()
                })
            } else {
                eventRef.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? [String:Any?],
                        let event = self.makeEventFromFirebase(value) {
                        if event.rsvpLimit != event.rsvpCount {
                            self.openEvents.append(event)
                        }
                        self.allEvents.append(event)
                    }
                })
            }
        }
    }
}
