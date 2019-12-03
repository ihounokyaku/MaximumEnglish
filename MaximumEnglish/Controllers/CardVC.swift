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

class CardVC: UIViewController {

    
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
    var lesson:Lesson?
    
    var customPracticeCards:List<Card>?
    
    var cardPool:List<Card> { return self.customPracticeCards ?? self.lesson?.cards ?? List<Card>() }
    
    var currentCard:Card?
    var speechRecognizer:SpeechRecognizer!
    var speechSynthesizer:SpeechSynthesizer!
    
    var back = false {
        didSet { self.toggleButtons() }
    }
    
    
    //MARK: - =============== SETUP ===============
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.speechRecognizer = SpeechRecognizer(delegate: self)
        self.speechSynthesizer = SpeechSynthesizer(delegate: self)
        self.showNextCard()
        
    }
    
    //-- For subclass setup --//
    func setUp(){}
    
    func toggleButtons() {
        self.answerLabel.isHidden = !self.back
        self.nextButton.isHidden = !self.back
        self.resultLabel.isHidden = !self.back
        self.ratingView.isHidden = !self.back
        self.answerLabel.isHidden = !self.back
    }
    
    
    
    //MARK: - =============== CARD ACTIONS ===============
    
    
    //-- perform action to get new card in subclass --//
    func getNextCard()->Card? { return nil }
    
    //-- show the next card and refresh UI --//
    func showNextCard() {
        
        guard let card = self.getNextCard() else { return }
        
        self.back = false
        self.resultLabel.text = ""

        self.currentCard = card
        
        self.questionLabel.text = self.currentCard?.question
        
        self.answerLabel.text = self.currentCard?.answer
        
        self.speakButton.currentState = .answer
    }
    
    
    //-- handle correct or incorrect answers --//
    func answered(_ answerType:AnserType) {
        
        let correct = answerType == .correct
        
        self.resultLabel.colorPassFail(pass: correct, passText: "Correct!", failText: "Incorrect!")
        
        self.answerLabel.colorPassFail(pass: correct)
       
        self.back = true

    }

    
    //MARK: - =============== USER INTERACTION ===============
    
    //-- handle answer button answers based on current state --//
    @IBAction func speakPressed(_ sender: AnswerButton) {
        
        guard let card = self.currentCard else { return }
        
        switch sender.currentState {
            
        case .answer:
            
            //-- begin speech recognition --//
            self.speechRecognizer.getSpeech()
            
        case .speaking:
            
            //-- end speech recognition --//
            sender.currentState = .processing
            self.speechRecognizer.finishSpeaking()
            
        case .listen:
            
            //-- listen to correct answer --//
            self.speechSynthesizer.speak(text: card.answer)
            sender.currentState = .listening
            
        case .tryAgain:
            self.tryPronunciationAgain()
            
        case .finish:
            self.finishPressed()
            
        default:
            
            break
            
        }
    }
    
    func finishPressed() {}
    
    func tryPronunciationAgain() { }
   
    
    @IBAction func nextButtonPressed(_ sender: Any) { self.showNextCard() }
    
    @IBAction func exOut(_ sender: Any) {
        self.cancelAction()
        
    }
    
    //-- handle cancel in subclass --//
    func cancelAction() { }
    
    //-- handle listened action in subclass --//
    func playedCorrectAnswer() {}
    
}


//MARK: - =============== SPEECH RECOGNITION  ===============
extension CardVC:SpeechRecognizerDelegate {
    
    func speechResultReturned(result: SFSpeechRecognitionResult) {
        guard let card = currentCard else {return}
        
        let allTranscriptions = result.transcriptions.map {$0.formattedString.lettersOnly()}
        if let index = allTranscriptions.firstIndex(of: card.answer.lettersOnly()) {
            
            let confidenceRatings = result.transcriptions[index].segments.map {$0.confidence}
            
            let averageRating = confidenceRatings.reduce(0, +) / Float(confidenceRatings.count)
            
            self.ratingView.currentRating = Rating.ForPercentage(averageRating)
            
//            for transcription in result.transcriptions {
//                print(transcription.formattedString)
//                let segments = transcription.segments
//
//                for segment in segments {
//                    print(segment.substring)
//                    print(segment.confidence)
//                }
//            }
            
            if !self.back { self.answered(.correct) }
            
        } else {
            self.ratingView.currentRating = .bad
            if !self.back { self.answered(.incorrect) }
        }
        
        self.speakButton.currentState = .listen
        
    }
    
    func speechRecognitionError(error: String) {
        self.speakButton.currentState = .answer
        print("Error with speech recognition!!!\n" + error)
        AlertManager.PresentErrorAlert(withTitle: "Sorry, I didn't catch that!", message: "Please make sure your microphone is enabled and that you are connected to the internet.")
    }
    
    func didBeginRecordingAudio() { self.speakButton.currentState = .speaking }
    
}


extension CardVC:SpeechSynthesizerDelegate {
    
    func didFinishSpeechUtterance(synthesizer: SpeechSynthesizer) { self.playedCorrectAnswer() }
    
}





