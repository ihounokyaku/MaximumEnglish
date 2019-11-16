//
//  PracticeCardVC.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/7/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit
import RealmSwift
import Speech

enum AnserType:String {
    
    case correct = "Correct!"
    case incorrect = "Wrong!"
    case pass = "Pass"
}

class PracticeVC: UIViewController {

    
    //MARK: - =============== IBOUTLETS ===============
    
    
    //MARK: - ===  LABELS  ===
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    //MARK: - ===  BUTTONS  ===
    @IBOutlet weak var speakButton: AnswerButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var ratingView: RatingView!
    
    
    //MARK: - =============== VARS ===============
    var lesson:Lesson!
    
    var currentCard:Card?
    var speechRecognizer:SpeechRecognizer!
    var speechSynthesizer:SpeechSynthesizer!
    
    var back = false {
        didSet { self.toggleButtons() }
    }
    
    var orderedCards:Results<Card> {
        
        return self.lesson.cards.sorted(byKeyPath: "privateInterval", ascending: true)
        
    }
    
    var topInterval:Int { self.orderedCards.last?.interval ?? 0 }
    
    var bottomInterval:Int { self.orderedCards.first?.interval ?? 0}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speechRecognizer = SpeechRecognizer(delegate: self)
        self.speechSynthesizer = SpeechSynthesizer(delegate: self)
        self.showNextCard()
        
    }
    
    func toggleButtons() {
        self.answerLabel.isHidden = !self.back
        self.nextButton.isHidden = !self.back
        self.resultLabel.isHidden = !self.back
        self.ratingView.isHidden = !self.back
        self.answerLabel.isHidden = !self.back
    }
    
    
    //MARK: - =============== CARD ACTIONS ===============
    
    
    func showNextCard() {
        
        self.back = false
        self.resultLabel.text = ""
        
        
        let maxInterval = Int.random(in: self.bottomInterval...self.topInterval)
        
        let cardPool = self.lesson.cards.filter("privateInterval <= %i", maxInterval)
        
        let cardIndex = Int.random(in: 0..<cardPool.count)
        
        guard cardIndex < cardPool.count else {
            print("cardIndex is \(cardIndex), cardpool count is \(cardPool.count)")
            self.currentCard = nil
            return
            
        }
        
        
        
        self.currentCard = cardPool[cardIndex]
        
        self.questionLabel.text = self.currentCard?.question
        
        self.answerLabel.text = self.currentCard?.answer
        
        self.speakButton.currentState = .answer
    }
    
    
    
    func answered(_ answerType:AnserType) {
        
        guard let card = self.currentCard else { return }
        
        switch answerType {
            
        case .correct:
            self.resultLabel.text = "Correct!"
            self.answerLabel.textColor = UIColor.green
            self.resultLabel.textColor = UIColor.green
            card.interval += 1
            card.timesSeen += 1
            
        case .incorrect:
            self.resultLabel.text = "Incorrect!"
            self.answerLabel.textColor = UIColor.red
            self.resultLabel.textColor = UIColor.red
            if card.interval > 0 { card.interval -= 1 }
            card.timesSeen += 1
            card.timesIncorrect += 1
            
        case .pass:
            break
            
        }
        
        self.back = true
        
        
    }
    
    
    //MARK: - =============== USER INTERACTION ===============
    
    @IBAction func speakPressed(_ sender: AnswerButton) {
        
        guard let card = self.currentCard else { return }
        
        switch sender.currentState {
            
        case .answer:
            
            self.speechRecognizer.getSpeech()
            
        case .speaking:
            
            sender.currentState = .processing
            self.speechRecognizer.finishSpeaking()
            
        case .listen:
            
            self.speechSynthesizer.speak(text: card.answer)
            sender.currentState = .listening
            
        case .tryAgain:
            
            self.ratingView.currentRating = nil
            self.speechRecognizer.getSpeech()
            
        default:
            
            break
            
        }
        
    }
   
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        self.showNextCard()
    }
    
    @IBAction func exOut(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - =============== SPEECH RECOGNITION  ===============
extension PracticeVC:SpeechRecognizerDelegate {
    
    func speechResultReturned(result: SFSpeechRecognitionResult) {
        guard let card = currentCard else {return}
        
        let allTranscriptions = result.transcriptions.map {$0.formattedString.lettersOnly()}
        if let index = allTranscriptions.firstIndex(of: card.answer.lettersOnly()) {
            
            let confidenceRatings = result.transcriptions[index].segments.map {$0.confidence}
            
            let averageRating = confidenceRatings.reduce(0, +) / Float(confidenceRatings.count)
            
            self.ratingView.currentRating = Rating.ForPercentage(averageRating)
            
            for transcription in result.transcriptions {
                print(transcription.formattedString)
                let segments = transcription.segments
                
                for segment in segments {
                    print(segment.substring)
                    print(segment.confidence)
                }  
            }
            
            if !self.back { self.answered(.correct) }
            
        } else {
            self.ratingView.currentRating = .bad
            if !self.back { self.answered(.incorrect) }
        }
        
        self.speakButton.currentState = .listen
        
    }
    
    func speechRecognitionError(error: String) {
        print(error)
    }
    
    func didBeginRecordingAudio() {
        
        self.speakButton.currentState = .speaking
    }
    
}

extension PracticeVC:SpeechSynthesizerDelegate {
    
    func didFinishSpeechUtterance(synthesizer: SpeechSynthesizer) {
        
        self.speakButton.currentState = .tryAgain
        
    }
    
}



