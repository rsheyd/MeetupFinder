//
//  EventCell.swift
//  MeetupFinder
//
//  Created by Roman Sheydvasser on 9/17/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var rsvpNumberLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
}
