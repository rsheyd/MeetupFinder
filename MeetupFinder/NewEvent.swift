//
//  NewEvent.swift
//  MeetupFinder
//
//  Created by Roman Sheydvasser on 8/25/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import UIKit
import Eureka

class NewEvent: FormViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Add New Event"
    }
}
