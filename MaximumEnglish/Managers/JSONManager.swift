//
//  JSONManager.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/2/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit
import SwiftyJSON

//MARK: - =============== KEYS ===============
enum JSONKey {
    
    case jsonID
    case levels
    case lessons
    case levelID
    case lessonID
    case lessonName
    case vocabularyCards
    case grammarCards
    case cardID
    case question
    case answer
    
    func keyValue()->String {
        
        switch self {
            
        case .jsonID, .lessonID:
            return "id"
        case .levels:
            return "levels"
        case .lessons:
            return "lessons"
        case .levelID, .lessonName:
            return "name"
        case .vocabularyCards:
            return "vocabulary"
        case .grammarCards:
            return "grammar"
        case .cardID, .question:
            return "question"
        case .answer:
            return "answer"
        }
        
    }
}
 

class JSONManager: NSObject {
    
    //MARK: - =============== FILE ===============
    
    var json:JSON
    
    //MARK: - =============== INIT ===============
    required init(json:JSON) {
        self.json = json
    }
    
    
    //MARK: - =============== STORED PROPERTIES ===============
    var id:String? {
        return self.json[JSONKey.jsonID.keyValue()].string
    }
    
    var levels:[JSON] { return self.json[JSONKey.levels.keyValue()].arrayValue }
    
    func lessons(forLevel level:JSON)-> [JSON] { return level[JSONKey.lessons.keyValue()].arrayValue }
    
    func vocabulary(forLesson lesson:JSON)->[JSON] { return lesson[JSONKey.vocabularyCards.keyValue()].arrayValue }
    
    func grammar(forLesson lesson:JSON)->[JSON] { return lesson[JSONKey.grammarCards.keyValue()].arrayValue }
    
    func question(forCard card:JSON)->String? { return card[JSONKey.question.keyValue()].string }
    
    func answer(forCard card:JSON)->String? { return card[JSONKey.answer.keyValue()].string }
    
    

    //MARK: - =============== CREATE EDIT ===============
    
    //MARK: - ===  GET OBJECTS  ===
    
    
    
    func lesson(fromJSON lJSON:JSON, inLevel level:Level)-> Lesson? {
        
        guard let id = lJSON[JSONKey.lessonID.keyValue()].string, let name = lJSON[JSONKey.lessonName.keyValue()].string else { return nil }
        
        guard self.vocabulary(forLesson: lJSON).count > 0 || self.grammar(forLesson: lJSON).count > 0 else { return nil }
        
        return level.lessons.filter("id == %@", id).first ?? DataManager.NewLesson(withName: name, id:id)
        
    }
    
    func level(fromJSON lJSON:JSON)-> Level? {
        
        guard let name = lJSON[JSONKey.levelID.keyValue()].string, let levelName = LevelName(rawValue: name) else {return nil}
        
        return DataManager.GetOrCreateLevel(withName: levelName)
        
    }
    
    //MARK: - ===  REMOVE OBJECTS  ===
    
    func removeDeletedLessons(fromLevel level:Level, updatedLessons:[JSON]) {
        
        let updatedLessonIDs = updatedLessons.map { $0[JSONKey.lessonID.keyValue()].stringValue }
        
        for lesson in level.lessons {
            
            if !updatedLessonIDs.contains(lesson.id) {
                
                lesson.selfDestruct()
                
            }
            
        }
        
    }
    
    func removeDeletedCards(fromLesson lesson:Lesson, updatedCards:[JSON]) {
        
        let updatedCardIDs = updatedCards.map { $0[JSONKey.cardID.keyValue()].stringValue }
        
        for card in lesson.cards {
            
            if !updatedCardIDs.contains(card.question) {
                
                if card.tests.count < 1 { DataManager.delete(object: card) }
                
            }
            
        }
        
        
    }
    
    
    
    
    //MARK: - ===  POPULATE DATABASE  ===
    func addCard(fromJSON cJSON:JSON, ofType type:CardType, toLesson lesson:Lesson) {
        
        guard let question = self.question(forCard: cJSON), let answer = answer(forCard: cJSON), lesson.cards.filter("question = %@", question).first == nil else { return }
        
        lesson.addNewCard(ofType: type, question: question, answer: answer)
        
    }
    
    //MARK: - ===  CHECK DATABASE   ===
    
    func updateDatabase() {
        
        //MARK: = iterate levels =
        
        for lJSON in self.levels {
            
            guard let level = self.level(fromJSON: lJSON) else { continue }
            
            let lessons = self.lessons(forLevel: lJSON)
            
            //MARK: = remove deleted lessons =
            self.removeDeletedLessons(fromLevel: level, updatedLessons: lessons)
            
            //MARK: = iterate and add lessons =
            for lJSON in lessons {
                
                guard let lesson = self.lesson(fromJSON: lJSON, inLevel: level) else { continue }
                
                let vocab = self.vocabulary(forLesson: lJSON)
                let grammar = self.grammar(forLesson: lJSON)
                
                 //MARK: = remove deleted cards =
                let allCards = vocab + grammar
                self.removeDeletedCards(fromLesson: lesson, updatedCards: allCards)
                
                
                //MARK: = iterate cards =
                for vJSON in vocab {
                    
                    self.addCard(fromJSON: vJSON, ofType: .vocab, toLesson: lesson)
                    
                }
                
                for gJSON in grammar {
                    
                    self.addCard(fromJSON: gJSON, ofType: .grammar, toLesson: lesson)
                    
                }
                
            }
            
        }
        
    }
    
}
