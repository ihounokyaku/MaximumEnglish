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
    
    static func PrimaryRegular(size:CGFloat)->UIFont{
        return UIFont(name: "PTSans-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func PrimaryBold(size:CGFloat)->UIFont{
        return UIFont(name: "PTSans-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func PrimaryItalic(size:CGFloat)->UIFont{
        return UIFont(name: "PTSans-Italic", size: size) ?? UIFont.systemFont(ofSize: size)
    }
   
    
    static var AlertTitleFont:UIFont {return UIFont.PrimaryBold(size:18)}
    
    static var AlertMessageFont:UIFont {return UIFont.PrimaryRegular(size:16)}
    
    static var TableRowTitle:UIFont {return UIFont.PrimaryRegular(size: 17)}
    
    static var NavBarTitle:UIFont{return UIFont.PrimaryRegular(size: 17)}
    
    static var CardQuestion:UIFont{return UIFont.PrimaryRegular(size: 40)}
    
    static var CardAnswer:UIFont{return UIFont.PrimaryRegular(size: 28)}
    
    static var HintTitle:UIFont{return UIFont.PrimaryRegular(size: 28)}
    
    static var HintDescription:UIFont{return UIFont.PrimaryRegular(size: 17)}
    
    static var NextButton:UIFont{return UIFont.PrimaryRegular(size: 22)}
    
    static var CardInfoTopView:UIFont{return UIFont.PrimaryRegular(size: 15)}
    
    static var CardInfoCategory:UIFont{return UIFont.PrimaryRegular(size: 18)}
    
    static var CardInfoItem:UIFont{return UIFont.PrimaryRegular(size: 18)}
    
}


