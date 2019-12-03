//
//  EditableTextAlert.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/19/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

class EditableTextAlert: CustomAlert, UITextFieldDelegate {

    var saveAction:UIAlertAction!
    var textFieldText:String?
    
    
    convenience init(title:String?, message:String?, preferredStyle:UIAlertController.Style, textFieldText:String?, textFieldAction:@escaping (String?)->Void) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        self.textFieldText = textFieldText
        self.saveAction = UIAlertAction(title: "Save", style: .default, handler: { (_) in
            if let fields = self.textFields, fields.count > 0 {
                
                textFieldAction(fields[0].text)
                
            }
        })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveAction.isEnabled = false
        self.addTextField { (textField) in
            textField.delegate = self
            textField.text = self.textFieldText
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        self.addAction(self.saveAction)
        self.addAction(cancelAction)
    // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.saveAction.isEnabled = true
        return true
    }

}
