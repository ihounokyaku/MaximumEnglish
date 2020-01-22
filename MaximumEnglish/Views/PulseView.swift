//
//  PulseView.swift
//  gradient
//
//  Created by Dylan Southard on 1/15/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

class PulseView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var pulseDuration:Double {
        
        return self.reverse ? 2 : 2
        
    }
    
    var pulseDelay:Double {
        
        return self.reverse ? 0.6 : 0.6
        
    }
    
    var numberPulses:Int {
        return self.reverse ? 5 : 5
    }
    
    var color:UIColor = UIColor.blue
    var reverse:Bool = false
    
    var pulseLayers = [CAShapeLayer]()
    var animating = false
    
    func animate(withColor color:UIColor, reverse:Bool) {
        self.color = color
        self.reverse = reverse
        if self.animating {
            self.stopAnimation(startNew: true)
        }
        
        self.createPulse()
    }
    
    func createPulse() {
        self.pulseLayers.removeAll()
        
        self.animating = true
        
        
        
        for _ in 0...self.numberPulses {
            
            let circularPath = UIBezierPath(arcCenter: .zero, radius: self.bounds.width / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            let pulseLayer = CAShapeLayer()
            
            pulseLayer.path = circularPath.cgPath
            
            pulseLayer.lineWidth = 2
            
            
            
            pulseLayer.fillColor = UIColor.clear.cgColor
            
            pulseLayer.lineCap = .round
            
            pulseLayer.position = CGPoint(x: self.frame.width / 2, y: self.frame.width / 2)
            
            self.layer.addSublayer(pulseLayer)
            
            pulseLayers.append(pulseLayer)
        }
        for (i, _) in self.pulseLayers.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * self.pulseDelay)) {
                self.animatePulse(atIndex: i)
            }
            
        }
        
    }
    
   
    func animatePulse(atIndex index:Int) {
        
        guard self.pulseLayers.count > index else { return }
        
        if self.reverse {
            pulseLayers[index].lineWidth = 2
            pulseLayers[index].strokeColor = UIColor.WhitePrimary().cgColor
            
        }
        
        pulseLayers[index].fillColor = self.color.cgColor
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        scaleAnimation.duration = self.pulseDuration
        scaleAnimation.fromValue = self.reverse ? 0.9 : 0.0
        scaleAnimation.toValue = self.reverse ? 0.0 : 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        scaleAnimation.autoreverses = false
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = self.pulseDuration
        opacityAnimation.fromValue = self.reverse ? 0.0 : 0.9
        opacityAnimation.toValue = self.reverse ? 0.9 : 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        opacityAnimation.autoreverses = false
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")
    }
    
    func stopAnimation(startNew:Bool = false) {
        for layer in self.pulseLayers {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
        self.animating = false
//        UIView.animate(withDuration: 0.1, animations: {
//            self.alpha = 0
//        }) { (complete) in
//
//            self.layer.removeAllAnimations()
//            self.animating = false
//
//            if startNew { self.createPulse() }
//
//            UIView.animate(withDuration: 0.1, animations: {
//                self.alpha = 1
//            }, completion: nil)
//        }
    }
    
    
    
}
