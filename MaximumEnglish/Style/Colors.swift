//
//  Colors.swift
//  FilmSwipe
//
//  Created by Dylan Southard on 2018/09/27.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static func HexWithAlpha(hex:String, alpha:CGFloat)-> UIColor{
        let color = UIColor(hexString: hex)
        return color.withAlphaComponent(alpha)
    }
    
    static func BlackBackgroundPrimary(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#252A26", alpha:alpha)
    }
    static func OffWhitePrimary(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#EEF2FA", alpha:alpha)
    }
    static func SecondaryDark(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#638278", alpha:alpha)
    }
    static func SecondaryLight(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#9BD5BF", alpha:alpha)
    }
    static func EmphasisDark(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#C1553E", alpha:alpha)
    }
    static func WhitePrimary(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#EFEFEF", alpha:alpha)
    }
    static func TextDarkPrimary(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#1D1E20", alpha:alpha)
    }
    static func TextLightPrimary(alpha:CGFloat = 1)-> UIColor{
        return OffWhitePrimary(alpha:alpha)
    }
    static func TextEmphasis(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#C1553E", alpha:alpha)
    }
    static func TextEmphasisLight(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#D07163", alpha:alpha)
    }
   
    
    static var SelectorWhite:UIColor {
        return UIColor.OffWhitePrimary(alpha:0.4)
    }
      
    
}

