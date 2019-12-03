//
//  WebQuearyManager.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/20/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit
import Alamofire

protocol WebQueryDelegate {
    
    func dataQueryComplete(manager:WebQueryManager, results:Data?, error:String?)
    
}

class WebQueryManager: NSObject {
    
    static var CurrentRequest:DataRequest?
    
    var delegate:WebQueryDelegate?
    
    init(delegate:WebQueryDelegate) { self.delegate = delegate }
    
    
    func executeDataRequest(atURL:URL) {
        
        print("executing request")
        //-- Cancel any current requests --//
        if let req = WebQueryManager.CurrentRequest {
            
            print("cancelling request")
            
            req.cancel() }
        
        //-- setup current request --//
        WebQueryManager.CurrentRequest = Alamofire.request(Presets.updateJSONURL)
        
        //-- execute and get response --//
        WebQueryManager.CurrentRequest?.responseData(completionHandler: { (response) in
            
            
            
            if response.result.isSuccess {
                print("response is success ")
                
                WebQueryManager.CurrentRequest = nil
                
                if let error = response.result.error { print(error.localizedDescription) }
                
                self.delegate?.dataQueryComplete(manager: self, results: response.data, error: nil)
                
            } else {
                
                print("response is failure ")
                WebQueryManager.CurrentRequest = nil
                
                if let error = response.result.error { print(error.localizedDescription) }
                
                self.delegate?.dataQueryComplete(manager: self, results: nil, error: "Could not download updates!")
                
            }
            
        })
    }
    

}
