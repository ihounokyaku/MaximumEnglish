//
//  File.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2019/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import RealmSwift

class Profile : Object {
    
    //MARK: - =============== STORED VARS ===============
    @objc private var privateID:String = ""
    @objc private var privateName:String = "Default"
    
    
    //MARK: - =============== COMPUTED VARS ===============
    
    var id:String { return self.privateID }
    
    var name:String {
        
        get { return self.privateName }
        
        set { DataManager.Write { self.privateName = newValue }}
        
    }
    
    
    //MARK: - =============== LISTS ===============
    
    let completedLevels = List<Level>()
    
    
    //MARK: - =============== INIT ===============
    
    convenience init(name:String) {
        
        self.init()
        self.privateName = name
        self.privateID = name + "\(Date().timeIntervalSince1970)"
        
    }
    
}
