//
//  Helper.swift
//  On The Map
//
//  Created by Roman Sheydvasser on 2/28/17.
//  Copyright © 2017 RLabs. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class Helper: UIViewController {
    static func displayAlert(_ message: String?) {
        if let message = message {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    static func displayUnwrappedAlert(_ message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func downloadImage(url: String, completionHandler: @escaping (_ image: UIImage?) -> Void) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                completionHandler(image)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func getEventCategoryImage(_ event: Event) -> UIImage? {
        var imageName = ""
        
        switch event.category {
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

// allows displayAlert/UI changes to be called from separate class (i.e. this one)
extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}

extension String {
    
    static func random10char(length: Int = 10) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
