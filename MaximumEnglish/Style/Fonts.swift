//
//  Fonts.swift
//  FilmSwipe
//
//  Created by Dylan Southard on 2018/09/27.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    func fontSizeByDevice(defaultSize:CGFloat, iPhone5:CGFloat, ipad:CGFloat, ipadPro:CGFloat? = nil)-> CGFloat {
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            return iPhone5
        } else if UIDevice.current.screenType == .ipad {
            if let pro = ipadPro {
                if UIDevice.isiPadPro {return pro}
            }
            
            return ipad
        }
        return defaultSize
    }
    
    static var PrimaryRegular:UIFont{
        return UIFont(name: "Nunito-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
    }
    
    static var PrimaryBold:UIFont{
        return UIFont(name: "Nunito-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12)
    }
    
    static var PrimaryItalic:UIFont{
        return UIFont(name: "Nunito-Italic", size: 12) ?? UIFont.systemFont(ofSize: 12)
    }
    
    static var PrimarySemiBold:UIFont{
        return UIFont(name: "Nunito-SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12)
    }
    
    static var GothicSemiBold:UIFont{
        return UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12) ?? UIFont(name: "Nunito-SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12)
    }
    
    static var AlertTitleFont:UIFont {return UIFont.PrimaryBold.withSize(18)}
    
    static var AlertMessageFont:UIFont {return UIFont.PrimaryRegular.withSize(16)}
    
}


