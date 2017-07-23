//
//  Menu.swift
//  MeetupFinder
//
//  Created by Roman Sheydvasser on 7/22/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let menu = ["Open Meetups", "All Meetups"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = menu[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch menu[indexPath.row] {
        case "Open Meetups":
            break
        case "All Meetups":
            performSegue(withIdentifier: "toNotifications", sender: self)
            break
        default:
            Helper.displayAlert("Setting not implemented yet.")
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let segueId = segue.identifier {
//            switch segueId {
//            case "toEditProfile":
//                let editProfileVC = segue.destination as! EditProfileDetailsVC
//                editProfileVC.userBeingEdited = currentUser
//                break
//            case "toCoffeeMap":
//                let coffeeMapVC = segue.destination as! CoffeeMapVC
//                guard let displayedUserLocation = displayedUser.location,
//                    let currentUserLocation = currentUser.location else {
//                        Helper.displayAlert("User locations for coffee map not found.")
//                        break
//                }
//                coffeeMapVC.selectedUserLocation = CLLocation(latitude: displayedUserLocation.latitude, longitude: displayedUserLocation.longitude)
//                coffeeMapVC.yourLocation = CLLocation(latitude: currentUserLocation.latitude, longitude: currentUserLocation.longitude)
//                coffeeMapVC.selectedUser = displayedUser
//                break
//            case "toChat":
//                let chatVC = segue.destination as! ChatVC
//                chatVC.chatPartner = displayedUser
//                break
//            default:
//                return
//            }
//        }
//    }
}
