//
//  ViewController.swift
//  MeetupFinder
//
//  Created by Roman Sheydvasser on 7/18/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SafariServices
import Firebase

class EventList: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let locationManager = CLLocationManager()
    let dateFormatter = DateFormatter()
    var currentLocation = CLLocation(latitude: 0, longitude: 0)
    var selectedEvent: Event?
    var events: [Event] = []
    
    var eventsRef: DatabaseReference!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    func refresh(sender:AnyObject) {
        openMeetupsPressed(sender)
    }
    
    @IBAction func openMeetupsPressed(_ sender: Any) {
        MeetupClient.shared.getMeetups(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude) {
            self.events = MeetupClient.shared.openEvents
            self.tableView.reloadData()
            self.getEventPhotos()
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func allMeetupsPressed(_ sender: Any) {
        MeetupClient.shared.getMeetups(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude) {
            self.events = MeetupClient.shared.allEvents
            self.tableView.reloadData()
            self.getEventPhotos()
        }
    }
    
    func getEventPhotos() {
        for event in MeetupClient.shared.allEvents {
            if let groupPhotoUrl = event.groupPhotoUrl {
                Helper.downloadImage(url: groupPhotoUrl, completionHandler: { (image) in
                    if let image = image {
                        let size = CGSize(width: 80.0, height: 80.0)
                        let resizedImage = image.af_imageAspectScaled(toFill: size)
                        let roundedImage = resizedImage.af_imageRounded(withCornerRadius: 10.0)
                        event.groupPhoto = roundedImage
                        self.tableView.reloadData()
                    }
                })
            } else {
                let catImage = Helper.getEventCategoryImage(event)
                let size = CGSize(width: 80.0, height: 80.0)
                let resizedImage = catImage?.af_imageAspectScaled(toFill: size)
                let roundedImage = resizedImage?.af_imageRounded(withCornerRadius: 10.0)
                event.groupPhoto = roundedImage
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsRef = Database.database().reference(withPath: "events")
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE h:mm a MMMd")
        
        // For use in foreground
        //self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "Events Near You"
        self.events = MeetupClient.shared.openEvents
        self.tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = manager.location {
            if currentLocation.coordinate.latitude == 0 {
                print("location = \(loc)")
                currentLocation = loc
                openMeetupsPressed(self)
            } else {
                //print(loc)
                currentLocation = loc
                MeetupClient.shared.currentLocation = loc
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell",
            for: indexPath) as? EventCell else {
                print("The dequeued cell is not an instance of EventCell.")
                return UITableViewCell()
        }
        
        if let latitude = event.latitude, let longitude = event.longitude {
            let eventLoc = CLLocation(latitude: latitude, longitude: longitude)
            let metersFromEvent = currentLocation.distance(from: eventLoc)
            let milesFromEvent = round(metersFromEvent/1609*10)/10
            cell.distanceLabel.text = "\(milesFromEvent) miles away"
            event.distanceFromMe = milesFromEvent
        }
        let eventDateRaw = event.time/1000
        let eventDateTime = dateFormatter.string(from: Date(timeIntervalSince1970: eventDateRaw))
        event.myDateTime = eventDateTime
        
        cell.nameLabel.text = event.name
        if let rsvpCount = event.rsvpCount, let rsvpLimit = event.rsvpLimit {
            cell.rsvpNumberLabel.text = "\(rsvpCount)/\(rsvpLimit) people going"
        }
        cell.dateTimeLabel.text = eventDateTime
        cell.groupNameLabel.text = event.groupName
        cell.imageView?.image = event.groupPhoto
        cell.separatorInset = UIEdgeInsets.zero // full lines between cells
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
        
//        if events.count > 0 {
//            let eventDateRaw = events[0].time/1000
//            let eventDate = Date(timeIntervalSince1970: eventDateRaw)
//            return eventDate.description
//        } else {
//            return ""
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedEvent = events[indexPath.row]
        performSegue(withIdentifier: "toEventDetails", sender: self)
        
//        let svc = SFSafariViewController(url: URL(string: event.link)!)
//        self.present(svc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier,
            let eventDetailsVC = segue.destination as? EventDetails,
            let selectedEvent = selectedEvent,
            segueId == "toEventDetails" {
                eventDetailsVC.event = selectedEvent
        }
    }
}

