//
//  Level.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2019/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import RealmSwift

class Lesson:Collection {
    
    //MARK: - =============== STORED VARS ===============
    @objc dynamic private var privateCompleted:Bool = false
    
    //MARK: - =============== COMPUTED VARS ===============
    var completed:Bool {
        
        get { return self.privateCompleted }
        
        set { DataManager.Write { self.privateCompleted = newValue } }
        
    }
    
    //MARK: - =============== COLLECTIONS ===============
    
    let tests = LinkingObjects(fromType: Test.self, property:"lesson")
    
    //MARK: - =============== FUNC ===============
    
    func selfDestruct() {
        
        for test in self.tests { DataManager.delete(object: test) }
        for card in self.cards { DataManager.delete(object: card) }
        
        DataManager.delete(object: self)
        
    }
}


