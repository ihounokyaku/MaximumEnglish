//
//  HamburgerX.swift
//  Constraints Animation
//
//  Created by Dylan Southard on 2019/05/03.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

class PlusMinusView: UIView {
    
    
    private var centerPoint:CGPoint {
        get {
            return CGPoint(x: (self.bounds.width - self.bounds.width / 2), y: self.bounds.height / 2)
        }
    }
    
   
    lazy var horizontalBar:UIView = self.line(rect:self.horizontalRect)

    lazy var verticalBar:UIView = self.line(rect: self.startMinus ? self.horizontalRect : self.verticalRect)
    
    var color = UIColor.green
    
    var lineThickness:CGFloat?
    
    
    var animationDuration:Double = 0.3
    
    private var horizontalRect:CGRect {
        
        return CGRect(x: 0, y: (self.bounds.height - self._lineThickness) / 2, width: self.bounds.width, height: self._lineThickness)
        
    }
    
    private var verticalRect:CGRect {return CGRect(x: (self.bounds.width - self._lineThickness) / 2, y: 0, width: self._lineThickness, height: self.bounds.height)}
    
    
    private var plus = false
    private var startMinus = false
    
    private var _lineThickness:CGFloat {
        get {
            return self.lineThickness ?? self.bounds.height / 6
        }
    }
    
    lazy private var animation:UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: self.animationDuration, curve: .easeOut, animations: nil)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.setUpView()
    }

    private func line(rect:CGRect)->UIView {
        let lineView = UIView()

        lineView.backgroundColor = self.color
        lineView.frame = rect
         return lineView
    }
    
    
    private func setUpView() {
        
        
        self.addSubview(horizontalBar)
        self.addSubview(verticalBar)
        
        self.setupAnimation()
        
    }
    
    func construct(color:UIColor = .black, lineThickness: CGFloat? = nil, animationDuration:Double = 0.3, startMinus:Bool = false) {
 
        self.color = color
        self.lineThickness = lineThickness
        
        self.animationDuration = animationDuration
        self.startMinus = startMinus
        self.setUpView()
    }
    
   func animateTransition() {
      
        if animation.isRunning { return }
        
        self.plus = !self.plus
        self.animation.isReversed = !self.plus
    
        self.animation.startAnimation()
    }
    
    
    func setupAnimation() {

        self.animation = UIViewPropertyAnimator(duration: self.animationDuration, curve: .easeOut, animations: nil)
        self.animation.addAnimations({
            
            
            self.horizontalBar.center = self.centerPoint
            self.verticalBar.center = self.centerPoint
            self.verticalBar.transform = CGAffineTransform(rotationAngle: CGFloat.degreesToRadians(self.startMinus ? 90 : -90))
            
        }, delayFactor: 0)
        
        self.animation.pausesOnCompletion = true
        
    }
    
    deinit {
        self.animation.stopAnimation(true)
        self.animation.finishAnimation(at: .current)
    }
    

}

extension CGFloat {
    static func degreesToRadians(_ degrees:CGFloat)-> CGFloat {
        return degrees * .pi / 180
    }
}
