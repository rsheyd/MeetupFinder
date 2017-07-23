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

class EventList: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation(latitude: 0, longitude: 0)
    var events: [Event] = []
    
    @IBOutlet weak var tableView: UITableView!

    @IBAction func openMeetupsPressed(_ sender: Any) {
        MeetupClient.shared.getMeetups(lat: String(currentLocation.coordinate.latitude), lon: String(currentLocation.coordinate.longitude)) {
            self.events = MeetupClient.shared.openEvents
            self.tableView.reloadData()
        }
    }
    @IBAction func allMeetupsPressed(_ sender: Any) {
        MeetupClient.shared.getMeetups(lat: String(currentLocation.coordinate.latitude), lon: String(currentLocation.coordinate.longitude)) {
            self.events = MeetupClient.shared.allEvents
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        //self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = manager.location {
            if currentLocation.coordinate.latitude == 0 {
                print("location = \(loc)")
            }
            currentLocation = loc
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
        
        cell.textLabel?.text = event.eventName
        cell.detailTextLabel?.text = "\(milesFromEvent) miles away, \(event.rsvpCount)/\(event.rsvpLimit) people going"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let events = MeetupClient.shared.allEvents
        if events.count > 0 {
            let eventDateRaw = events[0].time/1000
            let eventDate = Date(timeIntervalSince1970: eventDateRaw)
            return eventDate.description
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let event = MeetupClient.shared.allEvents[indexPath.row]
        
        let svc = SFSafariViewController(url: URL(string: event.link)!)
        self.present(svc, animated: true, completion: nil)
    }
}

