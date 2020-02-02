//
//  LessonHeaderCell.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 1/6/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

class LessonHeaderCell: UITableViewHeaderFooterView {
    static let reuseIdentifier: String? = "LessonHeader"

    @IBOutlet var accessoryView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func addAccessory(locked:Bool, headerHeight:CGFloat, rowWidth:CGFloat, tag:Int, open:Bool) {
        
        
        
        self.textLabel?.textColor = locked ? UIColor.TextDisabled : UIColor.TableCellPrimary
        for view in self.subviews {
            if let existingView = view as? UIImageView {
                existingView.removeFromSuperview()
            } else if let existingView = view as? PlusMinusView {
                existingView.removeFromSuperview()
            }
        }
        let accessoryHeightRatio:CGFloat = locked ? 0.3 : 0.4
        let accessoryViewWH:CGFloat = headerHeight * accessoryHeightRatio
        let accessoryViewY:CGFloat = (headerHeight - accessoryViewWH) / 2
        let accessoryBuffer:CGFloat = locked ? (20 + (headerHeight * 0.4 - accessoryViewWH) / 2) : 20
        let accessoryViewX:CGFloat = rowWidth - accessoryViewWH - accessoryBuffer
        let accessoryFrame = CGRect(x: accessoryViewX, y: accessoryViewY, width: accessoryViewWH, height: accessoryViewWH)
        
        
        if locked {
            let imageView = UIImageView(frame: accessoryFrame)
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.Lock
            self.addSubview(imageView)
            
        } else {
            
            let pmView = PlusMinusView(frame: accessoryFrame)
            pmView.tag = tag
            
            pmView.construct(color: UIColor.ExpandButton, lineThickness: 1, animationDuration: 0.3, startMinus: open)
            
            self.addSubview(pmView)
            
        }
        
        
        
    }

    
    
}
