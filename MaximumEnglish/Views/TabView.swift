//
//  TabView.swift
//  TabView
//
//  Created by Dylan Southard on 1/13/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

protocol TabViewDelegate {
    
    func tabViewWillOpen(_ tabView:TabView)
    
    func tabViewWillClose(_ tabView:TabView)
}

extension TabViewDelegate {
    
    func tabViewWillOpen(_ tabView:TabView){}
    
    func tabViewWillClose(_ tabView:TabView){}
}

@IBDesignable class TabView: UIView {
    
    var titleLabel:UILabel?
    
    var descriptionText:UITextView?
    
    
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
        _view.tintColor = UIColor.CardLeftTabImage
        return  _view
        
    }()
    
    //MARK: - =============== VARS ===============
    
    
    //MARK: - ===  STATE VARS  ===
    private var open = false
    private var animating = false

    
    //MARK: - ===  SETUP VARS  ===
    
    var delegate:TabViewDelegate?
    
    var animationDuration:Double = 0.3
    
    var bkgColor:UIColor = UIColor.yellow
    
    var strokeColor:UIColor = UIColor.blue
    
    var strokeRadius:CGFloat = 2
    
    var bottomCornerRadius:CGFloat = 5
    
    var buttonHeight:CGFloat = 0
    
    var textMargins:CGFloat = 10
    
    private var titleLabelHeight:CGFloat = 0
    
    private var textWidth:CGFloat {
        return self.bounds.width - self.tabWidth - textMargins * 2
    }
    
    //MARK: - ===  FRAME VARS  ===
    
    var tabWidth:CGFloat = 40
    
    var tabHeight:CGFloat = 40
    
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
        
        let tabPath = UIBezierPath()
 
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
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if self.open {
            return super.point(inside: point, with: event)
        }
        
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
    
    
    //MARK: - =============== ADD CONTENT ===============
    func addBottomButtons(_ buttons:[UIButton], height:CGFloat = 50) {
        
        self.buttonHeight = height
        
        let width = (self.bounds.width - self.tabWidth) / CGFloat(buttons.count)
        
        var currentX:CGFloat = 0
        
        for (i, button) in buttons.enumerated() {
            
            let _view = UIView()
            
            _view.backgroundColor = UIColor.clear
            
            _view.frame = CGRect(x: currentX, y: self.bounds.height - buttonHeight - self.strokeRadius / 2, width: width, height: buttonHeight)
            if i == buttons.count - 1 {
                _view.roundCorners(corners: [.layerMaxXMaxYCorner], radius: self.bottomCornerRadius)
            }
            
            _view.layer.borderColor = self.strokeColor.cgColor
            _view.layer.borderWidth = self.strokeRadius / 2
            self.addSubview(_view)
            
            button.frame = CGRect(x: 0, y: 0, width: self.bounds.height - self.buttonHeight, height: buttonHeight)
            
            
            _view.addSubview(button)
            
            currentX += width
            
        }
        
    }
    
    func addTitleLabel(text:String) {
        self.titleLabel = UILabel()
        
        self.titleLabelHeight = 30
        
        self.titleLabel!.frame = CGRect(x: self.textMargins, y: self.textMargins, width: self.textWidth, height: self.titleLabelHeight)
        
        self.titleLabel!.text = text
        
        self.titleLabel!.textAlignment = .center
        
        self.titleLabel!.font = UIFont.HintTitle
        
        self.titleLabel!.textColor = UIColor.TextSecondary
        
        self.addSubview(self.titleLabel!)
        
    }
    
    func addDescriptionText(text:String) {
        
        self.descriptionText = UITextView()
        
        let startY = self.titleLabel != nil ? self.titleLabel!.frame.height + textMargins : 0
        
        self.descriptionText?.frame = CGRect(x: self.textMargins, y:startY + textMargins, width: self.textWidth, height: self.bounds.height - startY - self.buttonHeight - self.textMargins * 2)
        
        
        self.descriptionText?.text = text
        
        self.descriptionText?.isEditable = false
        
        self.descriptionText?.isScrollEnabled = true
       
        self.descriptionText?.textColor = UIColor.TextPrimary
        
        self.descriptionText?.font = UIFont.HintDescription
        
        self.descriptionText?.backgroundColor = UIColor.clear
        
        self.addSubview(self.descriptionText!)
    }
    
    
    
    //MARK: - === OTHER SETUP  ===
    
    func construct(bkgColor:UIColor, strokeColor:UIColor, strokeRadius:CGFloat, image:UIImage? = nil, onPress:(@escaping ()->Void) = {}) {
        
        //-- setup vars --//
        self.onPress = onPress
        
        self.bkgColor = bkgColor
        
        self.strokeColor = strokeColor
        
        self.strokeRadius = strokeRadius
        
        self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
        
        
        
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
        guard let swipe = sender as? UISwipeGestureRecognizer, self.open == (swipe.direction == .left) else { return }
    
        self.animate()
    }
    
    @objc func buttonAction() {
        
        self.onPress()
        self.animate()
        
    }
    
    func animate() {
        guard self.animating == false else { return }
        
        if self.open {
            
            self.delegate?.tabViewWillClose(self)
            
        } else {
            
            self.delegate?.tabViewWillOpen(self)
            
        }
        
        
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

extension UIView {

   func roundCorners(corners:CACornerMask, radius: CGFloat) {
      self.layer.cornerRadius = radius
      self.layer.maskedCorners = corners
   }
}
