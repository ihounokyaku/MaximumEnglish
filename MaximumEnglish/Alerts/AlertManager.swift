//
//  DSAlert.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2019/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

class AlertManager: NSObject {
    
    
    
    static func PresentErrorAlert(withTitle title:String, message:String) {
        
        guard let vc = UIWindow().topViewController() else { return }
        
        let alertController = CustomAlert(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        
        defaultAction.setValue(UIColor.SecondaryDark(), forKey: "titleTextColor")
        alertController.addAction(defaultAction)
        vc.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
