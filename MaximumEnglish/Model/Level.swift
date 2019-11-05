//
//  Level.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2019/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import RealmSwift

enum LevelName:String, CaseIterable {
    
    case beginner = "Beginner"
    case lowerIntermediate = "Lower Intermediate"
    case intermediate = "Intermediate"
    case upperIntermediate = "Upper Intermediate"
    case advanced = "Advanced"
    
}

class Level:Object {
    
//MARK: - =============== STORED VARIABLES ===============
    @objc dynamic private var privateName:String = ""
    
//MARK: - =============== COMPUTED VARIABLES ===============
    
    var name:String {
        
        get { return self.privateName }
        
        set { DataManager.Write { self.privateName = newValue }}
    }
    
    var pastTests:Results<Test> {
        
        return DataManager.RealmDB.objects(Test.self).filter("level = %@", self)
        
    }
    
//MARK: - =============== LISTS ===============
    var lessons = List<Lesson>()
    var customCollections = List<Collection>()
    
//MARK: - =============== INIT ===============
    convenience init(name:String) {
        
        self.init()
        self.privateName = name
        
    }
    
}
