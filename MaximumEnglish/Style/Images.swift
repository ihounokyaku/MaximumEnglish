//
//  Images.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 1/12/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static var Lock:UIImage { return UIImage(named: "lock")! }
    
    static var HintImage:UIImage {return UIImage(named:"light_bulb")!}
    
    static func AnswerButton(for state:AnswerButtonState)->UIImage {
        return UIImage(named: "speak_answer")!
    }
    
}
