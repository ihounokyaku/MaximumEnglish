//
//  File.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2019/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import RealmSwift

enum CollectionType:String, CaseIterable {
    
    case custom = "Custom"
    case lesson = "Lesson"
    
}

class Collection:Object {
    
    
    //MARK: - =============== STORED VARIABLES ===============
    @objc dynamic var id:String = ""
    @objc dynamic private var privateName:String = ""
    @objc dynamic private var collectionType:String = "Custom"
    @objc dynamic private var privateNotes:String?
    
    //MARK: - =============== COMPUTED VARIABLES ===============
   
    var name:String {
        
        get { return self.privateName }
        
        set { DataManager.Write { self.privateName = newValue }}
        
    }
    
    var type:CollectionType { return self as? Lesson != nil ? .lesson : .custom }
    
    //MARK: - =============== Collections ===============
    let cards = List<Card>()
    
    
    //MARK: - =============== INIT ===============
    convenience init(name:String, id:String) {
        
        self.init()
        self.collectionType = self.type.rawValue
        self.privateName = name
        self.id = id
    }
    
    //MARK: - =============== FUNCTIONS ===============
    
    func addNewCard(ofType type:CardType, question:String, answer:String, notes:String) {
        
        guard self.cards.filter("question == %@", question).count == 0 else { return }
        
        guard let card = DataManager.NewCard(ofType: type, question: question, answer: answer, notes:notes) else { return }
        
        DataManager.Write { self.cards.append(card) }
        
    }
    
}
