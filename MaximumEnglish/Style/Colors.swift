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
    
    
    //MARK: - =============== MAIN PALLETE ===============
    static func Primary(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#000080", alpha:alpha)
    }
    
    static func PrimaryLight(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#4169e1", alpha:alpha)
    }
    
    static func PrimaryShade(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#e5e5f2", alpha:alpha)
    }
    
    static func Secondary(alpha:CGFloat = 1)-> UIColor{
        return HexWithAlpha(hex:"#efef08", alpha:alpha)
    }
    
    static func BlackPrimary(alpha:CGFloat = 1)-> UIColor {
        return HexWithAlpha(hex:"#535353", alpha:alpha)
    }
    
    static func LightGreyPrimary(alpha:CGFloat = 1)-> UIColor {
        return HexWithAlpha(hex:"#a0a0a0", alpha:alpha)
    }
    
    static func WhitePrimary(alpha:CGFloat = 1)-> UIColor {
        return HexWithAlpha(hex:"#ffffff", alpha:alpha)
    }

    static func Pass(alpha:CGFloat = 1)-> UIColor {
        return HexWithAlpha(hex:"#22ac38", alpha:alpha)
    }
    
    static func Fail(alpha:CGFloat = 1)-> UIColor {
        return HexWithAlpha(hex:"#c00a07", alpha:alpha)
    }
    
    //MARK: - =============== COLOR BY USE ===============
    
    static var NavMenuBkg:UIColor {return Primary() }
    
    static var NavMenuBtn:UIColor {return Secondary()}
    
    //MARK: - ===  TEXT  ===
    static var TextPrimary:UIColor {return BlackPrimary()}
    
    static var TextDisabled:UIColor {return LightGreyPrimary()}
    
    static var TextSecondary:UIColor {return PrimaryLight()}
    
    static var NavText:UIColor {return WhitePrimary()}
    
    static var PassText:UIColor {return Pass()}
       
    static var FailText:UIColor { return Fail() }
    
    
    //MARK: - ===  TABLE  ===
    static var ExpandButton:UIColor {return PrimaryLight()}
    
    static var TableEven:UIColor {return PrimaryShade()}
    
    static var TableOdd:UIColor{return WhitePrimary()}
    
    static var TableCellPrimary:UIColor{return TextPrimary}
    
    static var FooterBkg:UIColor{return NavMenuBkg}
    
    //MARK: - ===  CARD  ===
    static var CardLeftTab:UIColor{return Secondary(alpha: 0.9)}
    
    static var CardLeftTabOutline:UIColor { return PrimaryLight() }
    
    static var CardLeftTabImage:UIColor {return PrimaryLight()}
    
    static var SpeakBtnBkg:UIColor {return PrimaryLight(alpha:0.2)}
    
    static var SpeakBtnOutline:UIColor { return PrimaryLight() }
    
    static var SpeakBtnImage:UIColor { return PrimaryLight() }
    
    static var SpeakBtnAnimation:UIColor { return Primary() }
    
    static var SpeakBtnProcessingAnimation:UIColor { return Secondary() }
    
    static var SpeakBtnProcessingAnimationStroke:UIColor { return WhitePrimary() }
    
    static var ShieldViewBkg:UIColor {return BlackPrimary(alpha: 0.4)}
    
    static var NextButtonBkg:UIColor {return PrimaryLight()}
    
    static var NextButtonTxt:UIColor {return WhitePrimary()}
    
    static var ListeningPulse:UIColor {return PrimaryLight()}
    
    static var ThinkingPulse:UIColor {return Secondary()}
    
    static var QuestionNumber:UIColor {return BlackPrimary()}
    
    static var CardListBkg:UIColor {return PrimaryLight(alpha: 0.3)}
    
    
    //MARK: - ===  CARD INFO  ===
    
    static var cardInfoViewBkg:UIColor {return Primary()}
    
    static var cardInfoViewImg:UIColor {return Secondary()}
    
    static var cardInfoCategoryText:UIColor {return Secondary()}
    
    static var cardInfoItemText:UIColor {return WhitePrimary()}
    
    static var CardInfoHeaderText:UIColor {return WhitePrimary()}
    
    static var CardInfoTextBoxText:UIColor{return WhitePrimary()}
    
    static var CardInfoTextBoxBkg:UIColor {return UIColor.clear }
    
    static var CardInfoDivider:UIColor{return UIColor.Secondary()}
    
    
    //MARK: - =============== TEST RESULTS ===============
    static var TestResultCategory:UIColor{ return UIColor.TextPrimary }
    
    static var TestResultValue:UIColor{ return UIColor.TextPrimary }
}

