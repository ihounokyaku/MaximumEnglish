//
//  DataPopulator.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2019/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataPopulator: NSObject {
    
    static func PopulateInitialData() {
        
        guard DataManager.AllCards.count == 0 else { return }
        
        guard let url = Bundle.main.url(forResource: "InitialData", withExtension: "json"), let data = try? Data(contentsOf: url), let json = try? JSON(data: data) else { return }
       
        let jsonManager = JSONManager(json: json)
        
        jsonManager.updateDatabase()
        
    }
    
}
