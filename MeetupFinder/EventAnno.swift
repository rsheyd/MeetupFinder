//
//  EventAnno.swift
//  MeetupFinder
//
//  Created by Roman Sheydvasser on 9/9/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import MapKit

class EventAnno: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    class func fromJSON(_ json: [String]) -> String? {
        // 3
        return ""
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // MARK: - MapKit related methods
    
    // pinTintColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    func pinTintColor() -> UIColor  {
        switch discipline {
        case "Sculpture", "Plaque":
            return MKPinAnnotationView.redPinColor()
        case "Mural", "Monument":
            return MKPinAnnotationView.purplePinColor()
        default:
            return MKPinAnnotationView.greenPinColor()
        }
    }
    
    // annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: ["":""])
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}
