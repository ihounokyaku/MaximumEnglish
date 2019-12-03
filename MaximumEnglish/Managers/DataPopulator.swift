//
//  DataPopulator.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2019/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol DataPopulatorDelegate {
    
    func dataUpdateComplete(withError error:String?)
    
}

class DataPopulator: NSObject {
    
    var delegate:DataPopulatorDelegate?
    
    func executeUpdateQuery() {
        print("executing update query")
        WebQueryManager(delegate: self).executeDataRequest(atURL: Presets.updateJSONURL) }
    
    static func PopulateInitialData() {
        
        guard DataManager.AllCards.count == 0 else { return }
        
        guard let url = Bundle.main.url(forResource: "InitialData", withExtension: "json"), let data = try? Data(contentsOf: url), let json = try? JSON(data: data) else {
            
            AlertManager.PresentErrorAlert(withTitle: "ERROR", message: "Could not find initial database!")
            
            return
            
        }
       
        let jsonManager = JSONManager(json: json)
        
        jsonManager.updateDatabase()
        
    }

}

extension DataPopulator:WebQueryDelegate {
    
    func dataQueryComplete(manager: WebQueryManager, results: Data?, error: String?) {
        print("data query complete")
        guard let data = results else {
            print("no data!")
            self.delegate?.dataUpdateComplete(withError: error)
            return
        }
        
        guard let json = try? JSON(data:data) else {
            print("not json! \(data)")
            self.delegate?.dataUpdateComplete(withError: "Could not parse updates!")
            return
            
        }
        
        let jsonManager = JSONManager(json: json)
        jsonManager.delegate = self
        
        guard let jsonID = jsonManager.id else {
            print("no id")
            self.delegate?.dataUpdateComplete(withError: "Could not parse updates!")
            return
            
        }
        
        if jsonID != UserData.lastJSONID {
            print("going to update")
            jsonManager.updateDatabase()
            
        } else {
            print("id is id \(jsonID)")
            self.delegate?.dataUpdateComplete(withError: nil)
            
        }
        
    }
    
}

extension DataPopulator:JSONManagerDelegate {
    
    func finishedDataUpdate() {
        print("finished data update")
        self.delegate?.dataUpdateComplete(withError: nil) }

}
