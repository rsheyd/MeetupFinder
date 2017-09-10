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
    
    @IBOutlet weak var tableView: UITableView!

    @IBAction func openMeetupsPressed(_ sender: Any) {
        MeetupClient.shared.getMeetups(lat: String(currentLocation.coordinate.latitude), long: String(currentLocation.coordinate.longitude)) {
            self.events = MeetupClient.shared.openEvents
            self.tableView.reloadData()
        }
    }
    
    @IBAction func allMeetupsPressed(_ sender: Any) {
        MeetupClient.shared.getMeetups(lat: String(currentLocation.coordinate.latitude), long: String(currentLocation.coordinate.longitude)) {
            self.events = MeetupClient.shared.allEvents
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsRef = Database.database().reference(withPath: "events")
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        // For use in foreground
        //self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "Event List"
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let eventLoc = CLLocation(latitude: event.latitude, longitude: event.longitude)
        let metersFromEvent = currentLocation.distance(from: eventLoc)
        let milesFromEvent = round(metersFromEvent/1609*10)/10
        let eventDateRaw = event.time/1000
        let eventDate = dateFormatter.string(from: Date(timeIntervalSince1970: eventDateRaw))
        
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = "\(eventDate), \(milesFromEvent) miles away, \(event.rsvpCount)/\(event.rsvpLimit) people going"
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

