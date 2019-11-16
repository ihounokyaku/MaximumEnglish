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
    
}

class AnswerButton: UIButton {

    var currentState:AnswerButtonState = .answer {
        didSet {
            
            self.setTitle(self.currentState.rawValue, for: .normal)
            
        }
    }
    

}
