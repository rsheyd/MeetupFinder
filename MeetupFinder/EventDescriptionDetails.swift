//
//  EventDescriptionDetails.swift
//  MeetupFinder
//
//  Created by Roman Sheydvasser on 10/6/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import UIKit

class EventDescriptionDetails: UIViewController {
    @IBOutlet weak var descriptionTextView: UITextView!
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let event = event {
            if let description = event.description {
                descriptionTextView.attributedText = description.html2AttributedString
            } else {
                descriptionTextView.attributedText = NSAttributedString(string: "Event details are private.")
            }
            self.title = event.name
        }
    }
}
