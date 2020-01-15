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
        
        guard let vc = UIApplication.topViewController() else {
            
            print("no top vc!")
            return
            
        }
        
        let alertController = CustomAlert(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        
        defaultAction.setValue(UIColor.Primary(), forKey: "titleTextColor")
        alertController.addAction(defaultAction)
        vc.present(alertController, animated: true, completion: nil)
        
    }
    
    static func GetUserConfirmation(forAction confirmAction: @escaping ()->Void, alertTitle title:String, AlertMessage message:String, confirmText:String, cancelText:String) {
        
        
        guard let vc = UIApplication.topViewController() else {
            print("no vc!")
            return }
        
        let alertController = CustomAlert(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title:cancelText, style:.cancel)
        
        let confirmAction = UIAlertAction(title:confirmText, style: .destructive) { (action) in
            confirmAction()
        }
        
        alertController.addAction(defaultAction)
        alertController.addAction(confirmAction)
        
        vc.present(alertController, animated: true)
        
    }
    
    static func PresentEditableTextAlert(title:String, message:String?, textFieldText:String, action:@escaping (String?)->Void) {
        
        guard let vc = UIApplication.topViewController() else { return }
        
        let alertController = EditableTextAlert(title: title, message: message, preferredStyle: .alert, textFieldText: textFieldText, textFieldAction: action)
        
        vc.present(alertController, animated: true)
        
    }
    
}
