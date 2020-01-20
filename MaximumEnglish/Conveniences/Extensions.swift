//
//  Extensions.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2019/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit


extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}

extension UIApplication {
    
    static func topViewController()-> UIViewController? {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }
        
        return nil
    }
    
}

//MARK - ======DEVICE TYPE=======
extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR = "iPhone XR"
        case iPhone_XSMax = "iPhone XS Max"
        case ipad = "ipad"
        
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                return .ipad
            }
            return .unknown
        }
    }
    
    public class var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    public class var isiPadPro129: Bool {
        return isiPad && UIScreen.main.nativeBounds.size.height == 2732
    }
    
    public class var isiPadPro97: Bool {
        return isiPad && UIScreen.main.nativeBounds.size.height == 2048
    }
    
    public class var isiPadPro: Bool {
        return isiPad && (isiPadPro97 || isiPadPro129)
    }
    
}

extension String {
    
    func lettersOnly()->String {
        return self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters)
        
    }
    
}

extension Date {
    
    enum Format:String {
        
        case yearMonthDay = "yyyy-MM-dd"
        case yearMonthDayHourMin = "yyyy-MM-dd HH:mm"
        case hourMinuteSecond = "HH:mm:ss"
        
    }
    
    func toString(format:Date.Format)-> String{
        let formatter = DateFormatter()
        formatter.dateFormat =  format.rawValue
        return formatter.string(from: self)
    }
    
}

extension TimeInterval {
    
    func toString()-> String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}

extension UILabel {
    
    func colorPassFail(pass:Bool, passText:String? = nil, failText:String? = nil) {
        if let p = passText, let f = failText { self.text = pass ? p : f }
      
        self.textColor = pass ? UIColor.PassText : UIColor.FailText
        
    }
    
}
