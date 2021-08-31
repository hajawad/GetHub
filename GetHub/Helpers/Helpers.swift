//
//  Helpers.swift
//  GetHub
//
//  Created by Hashim Ahmed on 23/01/1443 AH.
//

import Foundation
import UIKit

class Helpers {
    static func showAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Error occured", message: "Error occured", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
