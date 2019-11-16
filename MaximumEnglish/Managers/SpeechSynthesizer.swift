//
//  SpeechSynthesizer.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/15/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit
import AVKit

protocol SpeechSynthesizerDelegate {
    
    func didFinishSpeechUtterance(synthesizer:SpeechSynthesizer)
    
}

class SpeechSynthesizer: NSObject {
    
    var synthesizer = AVSpeechSynthesizer()
    var rate = 1
    var delegate:SpeechSynthesizerDelegate?
    
    required init(delegate:SpeechSynthesizerDelegate) {
        super.init()
        self.synthesizer.delegate = self
        self.delegate = delegate
    }
    
    
    func speak(text:String) {
        
        let utterance = AVSpeechUtterance(string:text)
        self.synthesizer.speak(utterance)
        
    }

}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        self.delegate?.didFinishSpeechUtterance(synthesizer: self)
        
        self.synthesizer = AVSpeechSynthesizer()
        self.synthesizer.delegate = self
    }
    
}
