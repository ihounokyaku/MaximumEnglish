//
//  TabView.swift
//  TabView
//
//  Created by Dylan Southard on 1/13/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

@IBDesignable class TabView: UIView {
    
    
    //MARK: - =============== SUBVIEWS ===============
    
    //MARK: - ===  TAB BUTTON  ===
    lazy var button:UIButton = {
        
        let button = UIButton(frame: self.tabFrame)
        
        button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
        
        return button
        
    }()
    
    
    lazy var imageView:UIImageView = {
        let _view = UIImageView()
        
        let multiplier:CGFloat = 0.5
        
        let width = self.tabWidth * multiplier
        let height = width
        let x = self.tabX + (self.tabHeight - height) / 2
        let y = self.tabY + (self.tabWidth - width) / 2
    
        _view.frame = CGRect(x: x, y: y, width: width, height: height)
        
        _view.contentMode = .scaleAspectFit
        
        return  _view
        
    }()
    
    //MARK: - =============== VARS ===============
    
    
    //MARK: - ===  STATE VARS  ===
    private var open = false
    private var animating = false
    
    //MARK: - ===  SETUP VARS  ===
    private var animationDuration:Double = 0.3
    
    private var bkgColor:UIColor = UIColor.yellow
    
    private var strokeColor:UIColor = UIColor.blue
    
    private var strokeRadius:CGFloat = 2
    
    
    //MARK: - ===  FRAME VARS  ===
    
    let tabWidth:CGFloat = 40
    
    let tabHeight:CGFloat = 40
    
    private var tabX:CGFloat {return self.bounds.width - tabWidth - self.strokeRadius / 2 }
    
    private var tabY:CGFloat { return 0 + self.strokeRadius / 2 }
    
    private var tabFrame:CGRect { return CGRect(x: tabX, y: tabY, width: tabWidth, height: tabHeight) }
    
    var onPress: (()->Void) = {}
    
    //MARK: - =============== SETUP ===============
    
    
    //MARK: - ===  STYLE VIEW  ===
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        ctx.setFillColor(self.bkgColor.cgColor)
        
        ctx.saveGState()
        
//        let tabFrame = CGRect(x: tabX, y: tabY, width: tabWidth, height: tabHeight)
//
//        let tabPath = UIBezierPath(roundedRect: tabFrame,
//                                   byRoundingCorners: [.topRight, .bottomRight],
//                                   cornerRadii: CGSize(width: 15.0, height: 0.0))
//
//
//        let squarePath = UIBezierPath(rect: CGRect(x: 0, y: 0 + strokeRadius / 2, width: self.bounds.width - tabWidth, height: self.bounds.height - strokeRadius))
//
//        tabPath.append(squarePath)
        let tabPath = UIBezierPath()
        
        let bottomCornerRadius:CGFloat = 5
        
        tabPath.move(to: CGPoint(x: 0, y: self.tabY))
        
        tabPath.addLine(to: CGPoint(x: self.tabX + 20, y: self.tabY))
        
        tabPath.addArc(withCenter: CGPoint(x: self.tabX + 20, y: self.tabY + self.tabHeight / 2), radius: self.tabWidth / 2, startAngle: CGFloat(-90).radiansToDegrees(), endAngle: CGFloat(90).radiansToDegrees(), clockwise: true)
        
        tabPath.addLine(to: CGPoint(x:self.tabX, y: self.tabY + self.tabHeight))
        
       tabPath.addLine(to: CGPoint(x: self.tabX, y: self.bounds.height - (bottomCornerRadius + self.strokeRadius)))
        
        tabPath.addArc(withCenter: CGPoint(x: self.tabX - bottomCornerRadius, y: self.bounds.height - bottomCornerRadius - self.strokeRadius), radius: bottomCornerRadius, startAngle: CGFloat(360).radiansToDegrees(), endAngle: CGFloat(90).radiansToDegrees(), clockwise: true)
        
        tabPath.addLine(to: CGPoint(x: 0, y: self.bounds.height - self.strokeRadius))
        
        tabPath.lineWidth = self.strokeRadius
        
        self.strokeColor.setStroke()
        
        tabPath.stroke()
        tabPath.fill()
        
    }
    
    
    
    //MARK: - === OTHER SETUP  ===
    
    func construct(bkgColor:UIColor, strokeColor:UIColor, strokeRadius:CGFloat, image:UIImage? = nil, onPress:(@escaping ()->Void) = {}) {
        
        //-- setup vars --//
        self.onPress = onPress
        
        self.bkgColor = bkgColor
        
        self.strokeColor = strokeColor
        
        self.strokeRadius = strokeRadius
        
        self.imageView.image = image
        
        self.backgroundColor = UIColor.clear
        
        // -- setup gesture recognition --//
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(_:)))
        swipeRight.direction = .right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(_:)))
        swipeRight.direction = .left
        
        self.addGestureRecognizer(swipeRight)
        self.addGestureRecognizer(swipeLeft)
        
        //-- add subviews --//
        
        self.addSubview(self.imageView)
        
        self.addSubview(self.button)
 
    }
    
    
    //MARK: - =============== ANIMATION ===============
    
    @objc func swipe(_ sender: UIGestureRecognizer) {
        
        guard self.animating == false, let swipe = sender as? UISwipeGestureRecognizer, self.open == (swipe.direction == .left) else { return }
    
        self.animate()
    }
    
    @objc func buttonAction() {
        
        self.onPress()
        self.animate()
        
    }
    
    func animate() {
        self.animating = true
        UIView.animate(withDuration: self.animationDuration, animations: {
            
            self.transform = CGAffineTransform(translationX: self.open ? 0 : self.frame.width - self.tabWidth, y: 0)
            
            self.button.isUserInteractionEnabled = false
            
        }) { (complete) in
            
            self.animating = false
            
            self.open = !self.open
            
            self.button.isUserInteractionEnabled = true
            
        }
    }
    
}



extension CGFloat {
    func radiansToDegrees()-> CGFloat {
        return self  * CGFloat(Double.pi) / 180
    }
}
