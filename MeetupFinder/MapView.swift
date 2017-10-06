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
        MeetupClient.shared.getMeetups(lat: movedToLocation.latitude, long: movedToLocation.longitude) {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.addMeetupsToMap()
            self.getEventPhotos()
        }
    }
    
    func getEventPhotos() {
        for event in MeetupClient.shared.allEvents {
            guard let groupPhotoUrl = event.groupPhotoUrl else {
                continue
            }
            
            Helper.downloadImage(url: groupPhotoUrl, completionHandler: { (image) in
                if let image = image {
                    let size = CGSize(width: 80.0, height: 80.0)
                    let resizedImage = image.af_imageAspectScaled(toFill: size)
                    let roundedImage = resizedImage.af_imageRounded(withCornerRadius: 10.0)
                    event.groupPhoto = roundedImage
                }
            })
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
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = center
        mapView.setRegion(region, animated: true)
    }
    
    func addMeetupsToMap() {
        for event in MeetupClient.shared.allEvents {
            if let latitude = event.latitude, let longitude = event.longitude {
                let meetupPin = EventPin()
                meetupPin.event = event
                meetupPin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                meetupPin.title = event.name
                mapView.addAnnotation(meetupPin)
            }
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

        annoView.image = Helper.getEventCategoryImage(annotation.event)
        return annoView
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        refreshBtnPressed(self)
    }
}
