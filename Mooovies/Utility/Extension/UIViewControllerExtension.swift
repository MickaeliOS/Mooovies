//
//  UIViewControllerExtension.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
