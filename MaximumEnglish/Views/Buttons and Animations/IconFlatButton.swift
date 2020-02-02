//
//  IconFlatButton.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 1/20/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

enum FlatButtonImageOrientation {
    case left
    case right
}

class IconFlatButton: UIView {
    
    var label:UILabel?
    var imageView:UIImageView?
    var button:UIButton?
    var verticalMargin:CGFloat { return self.bounds.height * 0.25 }
    var horizontalMargin:CGFloat { return self.verticalMargin }
    var onPress: (()->Void) = {}
    
    var labelImageBuffer:CGFloat = 10
    var cornerRadius:CGFloat = 5
    
    
    var isEnabled:Bool = true{
        didSet {
            
            self.button?.isEnabled = self.isEnabled
            
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    func construct(title:String, font:UIFont, image:UIImage, bkgColor:UIColor, textColor:UIColor, onPress:(@escaping ()->Void), orientation:FlatButtonImageOrientation = .right) {
        
        let height = self.bounds.height - self.verticalMargin * 2
        let leftX = self.horizontalMargin
        let rightXStart = self.bounds.width - self.horizontalMargin
        let labelWidth = self.bounds.width - self.horizontalMargin * 2 - self.labelImageBuffer - height
        
        //--CONSTRUCT LABEL
        self.label = UILabel()
        self.label!.text = title
        self.label!.font = font
        self.label!.textColor = textColor
        
        self.label!.textAlignment = orientation == .right ? .right : .left
        self.label!.frame = CGRect(x: orientation == .right ? leftX : rightXStart - labelWidth, y: self.verticalMargin, width: labelWidth, height: height)
        self.addSubview(self.label!)
        
        //--CONSTRUCT IMAGE
        self.imageView = UIImageView()
        self.imageView!.image = image.withRenderingMode(.alwaysTemplate)
        self.imageView!.tintColor = textColor
        self.imageView!.contentMode = .scaleAspectFit
        self.imageView!.frame = CGRect(x: orientation == .left ? leftX : rightXStart - height, y: self.verticalMargin, width: height, height: height)
        self.addSubview(self.imageView!)
        
        //--CONSTRUCT BUTTON
        let _button = UIButton()
        _button.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        _button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        self.addSubview(_button)
        
        
        //--SET STYLE
        self.backgroundColor = bkgColor
        self.layer.cornerRadius = self.cornerRadius
        
        //--OTHER
        self.onPress = onPress
    }
    
    @objc private func buttonPressed() {
        print("pressed")
        self.onPress()
    }
    
}
