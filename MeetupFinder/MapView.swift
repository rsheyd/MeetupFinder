//
//  MapView.swift
//  MeetupFinder
//
//  Created by Roman Sheydvasser on 9/8/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func refreshBtnPressed(_ sender: Any) {
        let movedToLocation = mapView.centerCoordinate
        MeetupClient.shared.getMeetups(lat: String(movedToLocation.latitude), long: String(movedToLocation.longitude)) {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.addMeetupsToMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "Map View"
        setMapToLocation(MeetupClient.shared.currentLocation)
        addMeetupsToMap()
    }
    
    func mapSetup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func setMapToLocation(_ location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6))
        region.center = center
        mapView.setRegion(region, animated: true)
    }
    
    func addMeetupsToMap() {
        for event in MeetupClient.shared.allEvents {
            let meetupPin = EventPin()
            meetupPin.event = event
            meetupPin.coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
            meetupPin.title = event.name
            mapView.addAnnotation(meetupPin)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoId = "annoId"
        
        if let annotation = annotation as? EventPin {
        var annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: annoId)
        
        if let queuedAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoId) {
            queuedAnno.annotation = annotation
            annoView = queuedAnno
        } else {
            annoView.canShowCallout = true
            }

        annoView.image = getPinImage(annotation)
        return annoView
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    func getPinImage(_ annotation: EventPin) -> UIImage? {
        var imageName = ""
        
        switch annotation.event.category {
        case "Arts & Culture":
            imageName = "arts50"
        case "Book Clubs":
            imageName = "books50"
        case "Career & Business":
            imageName = "business50"
        case "Cars & Motorcycles":
            imageName = "cars50"
        case "Community & Environment":
            imageName = "community50"
        case "Dancing":
            imageName = "dance50"
        case "Education & Learning":
            imageName = "education50"
        case "Fashion & Beauty":
            imageName = "fashion50"
        case "Fitness":
            imageName = "fitness50"
        case "Food & Drink":
            imageName = "food50"
        case "Games":
            imageName = "games50"
        case "Health & Wellbeing":
            imageName = "health50"
        case "Hobbies & Crafts":
            imageName = "hobbies50"
        case "Language & Ethnic Identity":
            imageName = "languages50"
        case "LGBT":
            imageName = "lgbt50"
        case "Lifestyle":
            imageName = "lifestyle50"
        case "Movements & Politics":
            imageName = "politics50"
        case "Movies & Film":
            imageName = "movies50"
        case "Music":
            imageName = "music50"
        case "New Age & Spirituality":
            imageName = "spirituality50"
        case "Outdoors & Adventure":
            imageName = "outdoors50"
        case "Paranormal":
            imageName = "paranormal50"
        case "Parents & Family":
            imageName = "family50"
        case "Pets & Animals":
            imageName = "pets50"
        case "Photography":
            imageName = "photography50"
        case "Religion & Beliefs":
            imageName = "religion50"
        case "Sci-Fi & Fantasy":
            imageName = "scifi50"
        case "Singles":
            imageName = "singles50"
        case "Socializing":
            imageName = "socializing50"
        case "Sports & Recreation":
            imageName = "sports50"
        case "Support":
            imageName = "support50"
        case "Tech":
            imageName = "tech50"
        case "Writing":
            imageName = "writing50"
        default:
            imageName = "icons8-group"
        }
        
        return UIImage(named: imageName)
    }
}
