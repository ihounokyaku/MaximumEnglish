//
//  AnswerButton.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/15/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

enum AnswerButtonState:String, CaseIterable {
    
    case answer = "Speak Answer"
    case listen = "Listen"
    case listening = ""
    case speaking = "Stop"
    case processing = "Processing"
    case tryAgain = "Try Again"
    case finish = "Finish"
    
}


class AnswerButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        
        self.layer.cornerRadius = rect.width / 2
        self.clipsToBounds = true
        self.layer.backgroundColor = UIColor.SpeakBtnBkg.cgColor
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.SpeakBtnOutline.cgColor
        self.imageView!.tintColor = UIColor.SpeakBtnImage
        self.imageView!.image = UIImage.AnswerButton(for: self.currentState)
    }

    var currentState:AnswerButtonState = .answer {
        didSet {
            
//            self.setImage(UIImage.AnswerButton(for: self.currentState), for: .normal)
//            self.setTitle(self.currentState.rawValue, for: .normal)
            
        }
    }
    

}
