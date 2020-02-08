//
//  StyledTableVC.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2/8/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

class StyledTableVC: UIViewController {


    lazy var tableView:StyledTableView = {
        
        return StyledTableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - BottomFrameHeight))
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(FooterView())
        self.view.addSubview(self.tableView)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
