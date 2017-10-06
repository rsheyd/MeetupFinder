//
//  EventDetails.swift
//  MeetupFinder
//
//  Created by Roman Sheydvasser on 8/17/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import UIKit

class EventDetails: UIViewController {
    
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var shortDescriptionButton: UIButton!
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortDescriptionButton.setTitleColor(UIColor.black, for: .normal)
        shortDescriptionButton.titleLabel?.numberOfLines = 4
        if let event = event {
            if let description = event.description {
                shortDescriptionButton.setTitle(description.html2String, for: .normal)
                //shortDescriptionButton.setAttributedTitle(description.html2AttributedString, for: .normal)
            } else {
                shortDescriptionButton.setTitle("Event details are private.", for: .normal)
            }
            self.title = event.name
        } else {
            print("Could not retrieve event.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier,
            let eventDescriptionVC = segue.destination as? EventDescriptionDetails,
            let selectedEvent = event,
            segueId == "toEventDescriptionDetails" {
            eventDescriptionVC.event = selectedEvent
        }
    }
}
