//
//  Utils.swift
//  ForecastApp
//
//  Created by Arnaldo Gnesutta on 06/04/2018.
//  Copyright © 2018 Arnaldo Gnesutta. All rights reserved.
//

import UIKit
import ACProgressHUD_Swift

extension UIViewController {
    func showAlert(title: String, message: String, actionTitle: String) {
        if ACProgressHUD.shared.isBeingShown { ACProgressHUD.shared.hideHUD() }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
