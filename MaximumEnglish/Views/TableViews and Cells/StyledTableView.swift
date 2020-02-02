//
//  StyledTableView.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2/1/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

class StyledTableView: UITableView {

    
    func setUp(delegate:UITableViewDelegate & UITableViewDataSource) {
        
        self.delegate = delegate
        
        self.dataSource = delegate
        
        self.tableFooterView = UIView(frame: .zero)
        
        self.separatorStyle = .none
        
    }

}
