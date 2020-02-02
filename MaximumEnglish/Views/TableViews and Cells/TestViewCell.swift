//
//  TestViewCell.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2/1/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit



class TestViewCell: StyledCell {
    
    let margin:CGFloat = 16
    
    var accessoryWidthRatio:CGFloat = 2
    
   var pass:Bool = true
    
    var passText = "PASS"
    var failText = "FAIL"
    
    lazy var passFailLabel:UILabel = {
        let label = UILabel()
        
        label.font = UIFont.TestViewCellAccessory
        
        let labelHeight = self.bounds.height * 0.6
        let labelWidth = labelHeight * self.accessoryWidthRatio
        
        print(self.bounds.width)
        
        label.frame = CGRect(x: self.bounds.width - margin - labelWidth, y: (self.bounds.height - labelHeight) / 2, width: labelWidth, height: labelHeight)
        
        label.layer.cornerRadius = labelHeight / 2
        
        label.textColor = UIColor.WhitePrimary()
        
        label.textAlignment = .center
        
        return label
    }()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //--PASS/FAIL LABEL--//
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.passFailLabel.layer.backgroundColor = self.pass ? UIColor.Pass().cgColor : UIColor.Fail().cgColor
        self.passFailLabel.text = self.pass ? self.passText : self.failText
        
        if !self.passFailLabel.isDescendant(of: self) {
            
            self.addSubview(self.passFailLabel)
            
        }
        
        self.textLabel?.frame.size = CGSize(width: self.frame.width - margin - self.passFailLabel.bounds.width - 8, height: self.textLabel?.bounds.height ?? 0)
    }
    
    
    
    

   
}
