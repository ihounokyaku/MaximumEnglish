//
//  FooterView.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2/1/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

class FooterView: UIView {

    
    override init(frame: CGRect) {
      super.init(frame: frame)
        self.setup()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
        self.setup()
    }
    
    //common func to init our view
    private func setup() {
        
      self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - BottomFrameHeight, width: UIScreen.main.bounds.width, height: BottomFrameHeight)
        
      self.backgroundColor = UIColor.FooterBkg
    }
    

}
