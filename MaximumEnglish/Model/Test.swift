//
//  Test.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/2/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import RealmSwift

enum testType:String {
    case vocab = "Vocabulary"
    case grammar = "Grammar"
    case mixed = "Vocabulary and Grammar"
}

class Test:Object {
    
    //MARK: - ================ STORED VARIABLES ================

    @objc dynamic private var score:Int = 0
    
    @objc dynamic var dateStarted:Date = Date()
    
    @objc dynamic var dateFinished:Date?
    
    @objc dynamic var passThresh:Double = 0.9
    
    @objc dynamic var passed:Bool = false
    
    //MARK: - ================= LINKED OBJECTS =================
    
    @objc dynamic var lesson:Lesson?
    
    var cards = List<Card>()
    
    var answersCorrect = List<Bool>()
    
    
    //MARK: - ================== INITIALIZERS ==================
    
    convenience init(cards:List<Card>, lesson:Lesson, passThresh:Double) {
        self.init()
        
        self.cards = cards
        self.lesson = lesson
        self.dateStarted = Date()
        self.passThresh = passThresh
    }
    
    
    //MARK: - =================== FUNCTIONS ====================
    
    func markAnswer(forCard card:Card, correct:Bool) {
        
        self.answersCorrect.append(correct)
        if correct { self.score += 1 }
        
        card.timesSeen += 1
        if !correct { card.timesIncorrect += 1 }
    }
    
    func finish() {
        
        self.passed = Double(self.score) / Double(self.cards.count) >= self.passThresh
        
        do {
            
            try DataManager.RealmDB.write{ DataManager.RealmDB.add(self) }
            
        } catch {
            
            AlertManager.PresentErrorAlert(withTitle: "Error Saving Test!", message: error.localizedDescription)
            
        }
        
    }
    
    
    
}
