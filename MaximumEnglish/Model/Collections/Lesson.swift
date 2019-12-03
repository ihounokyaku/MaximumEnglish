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
    
    var locked:Bool {
        if self.completed { return false }
        
        guard let level = self.level.first, let index = level.lessons.index(of: self) else {return true}
        
        
        return !(index == 0 || level.lessons[index - 1].completed)
    }
    
    //MARK: - =============== COLLECTIONS ===============
    
    let tests = LinkingObjects(fromType: Test.self, property:"lesson")
    let level = LinkingObjects(fromType:Level.self, property:"lessons")
    
    //MARK: - =============== FUNC ===============
    
    func selfDestruct() {
        
        for test in self.tests { DataManager.delete(object: test) }
        for card in self.cards { DataManager.delete(object: card) }
        
        DataManager.delete(object: self)
        
    }
    
    func createTest()->Test {
        
        let cards = List<Card>()
        cards.append(objectsIn: self.cards.shuffled().prefix(Presets.NumTestQuestions))
        return Test(cards: cards, lesson: self, passThresh: Presets.PassThresh)
        
    }
}


