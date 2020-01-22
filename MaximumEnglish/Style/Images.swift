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
    
    static var HintImage:UIImage {return UIImage(named:"hint")!}
    
    static var DescriptionImage:UIImage {return UIImage(named:"note")!}
    
    static var NextArrow:UIImage {return UIImage(named:"chevron_right")!}
    
    static var CardInfoTop:UIImage {return UIImage(named:"chevron_up")!}
    
    static var CardInfoBottom:UIImage {return UIImage(named:"pencil")!}
    
    static func AnswerButton(for state:AnswerButtonState)->UIImage? {
        var imageName = ""
        
        switch state {
        case .answer, .tryAgain, .speaking:
            imageName = "speak_answer"
            
        case .listen, .listening:
            imageName = "listen"
            
        default:
            break
        }
        
        return UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        
    }
    
    
    
}
