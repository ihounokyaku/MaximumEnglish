//
//  ShieldView.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2/2/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

protocol ShieldViewDelegate {
    func ShieldViewTapped()
}

let ShieldBlur = UIBlurEffect(style: .light)

class ShieldView: UIVisualEffectView {

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var delegate:ShieldViewDelegate?
    
    var animationDuration:Double = 0.3
    
    var blurEffect = UIBlurEffect(style: .light)
    
    override init(effect: UIVisualEffect?) {
        
        super.init(effect: effect)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        
        self.isHidden = true
        
        self.alpha = 0
        
        let gesture = UITapGestureRecognizer(target: self, action:#selector(self.tapped))
        
        self.addGestureRecognizer(gesture)
    }
    
    @objc func tapped() {
        self.delegate?.ShieldViewTapped()
    }
    
    func show(withDuration duration:Double? = nil) {
        UIView.animate(withDuration: duration ?? self.animationDuration) {
                   self.isHidden = false
            self.alpha = 0.7
               }
    }
    
    func hide(withDuration duration:Double? = nil) {
        UIView.animate(withDuration: duration ?? self.animationDuration, animations: {
            self.alpha = 0
        }) { (complete) in
            self.isHidden = true
        }
    }
    

}
