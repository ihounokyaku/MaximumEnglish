//
//  StyledCell.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2/1/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

class StyledCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func style(forRow row:Int, selectable:Bool = true) {
        
        self.selectionStyle = .none
        
        self.textLabel?.font = UIFont.TableRowTitle
        
        self.textLabel?.textColor = selectable ? UIColor.TableCellPrimary : UIColor.TextDisabled
        
        self.backgroundColor = row % 2 == 0 ? UIColor.TableOdd : UIColor.TableEven
        
    }

}
