//
//  SpeechRecognizer.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit
import Speech

protocol SpeechRecognizerDelegate {
    
    func speechResultReturned(result:SFSpeechRecognitionResult)
    func speechRecognitionError(error:String)
    func didBeginRecordingAudio()
    
}

class SpeechRecognizer: NSObject {
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer:SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask:SFSpeechRecognitionTask?
    var delegate:SpeechRecognizerDelegate?
    var speaking = false
    
    
    init(delegate:SpeechRecognizerDelegate) {
        
        super.init()
        
        self.delegate = delegate
        
    }
    
    func getSpeech() {
        let node = self.audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            self.speaking = true
            self.delegate?.didBeginRecordingAudio()
        } catch {
            self.delegate?.speechRecognitionError(error: error.localizedDescription)
            return
        }
        
        
    }
    
    func finishSpeaking() {
        self.speaking = false
        guard let rec = SFSpeechRecognizer(), rec.isAvailable else {
            self.recognitionTask = nil
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.request.endAudio()
            self.delegate?.speechRecognitionError(error: "Recognizer not available")
            return
        }
        
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.request.endAudio()
        
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with:self.request, resultHandler:  { result, error in
            
            if let result = result {
                if result.isFinal {
                    
                    self.delegate?.speechResultReturned(result: result)
                    self.recognitionTask?.finish()
                    self.recognitionTask = nil
                }
                
            } else {
                
                self.recognitionTask?.finish()
                self.recognitionTask = nil
                
                self.delegate?.speechRecognitionError(error: error?.localizedDescription ?? "No speech results")
                
            }
            
        })
    }
}


