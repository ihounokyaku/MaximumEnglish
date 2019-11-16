//
//  DataManger.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2019/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit
import RealmSwift

class DataManager: NSObject {
    

    //MARK: - =============== DATABASE ===============
    
    static private var RealRealm:Realm?
    
    static var RealmDB:Realm {
        
        if RealRealm == nil {
            RealRealm = try! Realm.init(configuration: Realm.Configuration.defaultConfiguration)
        }
        
        return RealRealm!
        
    }
    
    //MARK: - =============== DATACOLLECTIONS ===============
    
    static var Levels:[Level] = {
        var levels = [Level]()
        
        for name in LevelName.allCases { levels.append(GetOrCreateLevel(withName: name)) }
        
        return levels
        
    }()
    
    static var AllCards:Results<Card> {
        
        return RealmDB.objects(Card.self).sorted(byKeyPath: "question", ascending: true)
        
    }
    
    
    //MARK: - =============== CREATE ===============
    
    static func NewCard(ofType type:CardType, question:String, answer:String, notes:String)-> Card? {
        
        let card = Card(type: type, question: question, answer: answer, notes:notes)
        
        return SavedObject(card) as? Card
        
    }
    
    static func NewLesson(withName name:String, id:String)->Lesson? { return SavedObject(Lesson(name: name, id:id)) as? Lesson }
    
    static func SavedObject(_ object:Object, presentError:Bool = false)->Object? {
        
        do {
            try RealmDB.write{ RealmDB.add(object) }
            
            return object
            
        } catch {
            
            if presentError {
                
                AlertManager.PresentErrorAlert(withTitle: "Error!", message: "Could not add object to database!")
            }
            
            print(error.localizedDescription)
            
            return nil
        }
    }

    
    //MARK: - =============== READ ===============
    
    
    static func GetOrCreateLevel(withName levelName:LevelName)-> Level {
        
        if let level = RealmDB.objects(Level.self).filter("name == %@", levelName.rawValue).first {
            
            return level
            
        } else {
            
            let level = Level(name: levelName.rawValue)
            
            Write { RealmDB.add(level) }
            
            return level
            
        }
        
    }
    
    
    
    
    //MARK: - =============== UPDATE ===============
    
    static func Write(_ writeFunction:()->Void) {
        
        do {
            try RealmDB.write {
                writeFunction()
            }
        } catch {
    
            AlertManager.PresentErrorAlert(withTitle: "Error!", message: "Could not save to database!")
            
            print(error.localizedDescription)
            
        }
        
    }
    
    //MARK: - =============== DESTROY ===============
    
    static func delete(object:Object) { Write { RealmDB.delete(object) } }
    
}
