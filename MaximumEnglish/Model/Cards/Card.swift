//
//  Card.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2019/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import RealmSwift

enum CardType:String, CaseIterable {
    
    case vocab = "Vocabulary"
    case grammar = "Grammar"
    
}

class Card:Object {
    
//MARK: - =============== STORED VARIABLES ===============

    @objc dynamic var question = ""
    @objc dynamic var answer = ""
    @objc dynamic var notes = ""
    @objc dynamic var privateHint:String?
    @objc dynamic var level:Int = 0
    @objc dynamic private var cardType:String = "Vocabulary"
    @objc dynamic private var privateInterval:Int = 0
    @objc dynamic private var privateTimesSeen:Int = 0
    @objc dynamic private var privateTimesIncorrect:Int = 0

    
//MARK: - =============== COMPUTED VARIABLES ===============
    
    var type:CardType { return CardType(rawValue: self.cardType) ?? .vocab }
    
    var interval:Int {
        
        get { return self.privateInterval }
        
        set { DataManager.Write { self.privateInterval = newValue } }
        
    }
    
    var timesSeen:Int {
        
        get { return self.privateTimesSeen }
        
        set { DataManager.Write { self.privateTimesSeen = newValue } }
        
    }
    
    var timesIncorrect:Int {
        
        get { return self.privateTimesIncorrect }
        
        set { DataManager.Write { self.privateTimesIncorrect = newValue } }
        
    }
    
    var hint:String? {
        
        get { return self.privateHint }
        
        set { DataManager.Write { self.privateHint = newValue }}
        
    }
    
    
    
    
//MARK: - =============== COLLECTIONS ===============
    
    let collections = LinkingObjects(fromType: Collection.self, property: "cards")
    
    let tests = LinkingObjects(fromType: Test.self, property:"cards")
    
//MARK: - =============== INIT ===============
    
    convenience init(type:CardType, question:String, answer:String, notes:String) {

        self.init()
        self.cardType = type.rawValue
        self.question = question
        self.answer = answer
        
    }
    
    
    
    
}
