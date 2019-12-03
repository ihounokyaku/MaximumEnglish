//
//  UserData.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/20/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

class UserData: NSObject {

    static var lastJSONID:String {
        
        get { return UserDefaults.standard.value(forKey: "jsonID") as? String ?? "" }
        
        set { UserDefaults.standard.setValue(newValue, forKey: "jsonID")}
        
    }
    
}
