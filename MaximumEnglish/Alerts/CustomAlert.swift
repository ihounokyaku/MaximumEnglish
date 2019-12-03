//
//  CustomAlert.swift
//  FilmSwipe
//
//  Created by Dylan Southard on 2018/10/20.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import UIKit

class CustomAlert: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleFont = [NSAttributedString.Key.font: UIFont.AlertTitleFont]
        let messageFont = [NSAttributedString.Key.font: UIFont.AlertMessageFont]
        var ms = ""
        var ti = ""
        
        
        if let message = self.message {
            ms = message
        }
        
        if let title = self.title {
            ti = title
        }
        let titleAttrString = NSMutableAttributedString(string: ti, attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: ms, attributes: messageFont)
        self.setValue(titleAttrString, forKey: "attributedTitle")
        self.setValue(messageAttrString, forKey: "attributedMessage")
        self.view.layer.cornerRadius = 50
    }

}
