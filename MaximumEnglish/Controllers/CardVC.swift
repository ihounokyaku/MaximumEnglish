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

enum AnswerType:String {
    
    case correct = "Correct!"
    case incorrect = "Wrong!"
    case pass = "Pass"
}

class CardVC: UIViewController, AnswerButtonDelegate {

    
    //MARK: - =============== VIEWS ===============
    
    lazy var ratingView:RatingView = {
        let height = self.speakButton.bounds.height * 0.32
        let width = self.view.frame.width * 0.68
        
       return RatingView(frame: CGRect(x: (self.view.frame.width - width) / 2, y: self.resultLabel.frame.origin.y + self.resultLabel.bounds.height + 30, width: width, height: height))
    }()
    
    
    
    //MARK: - ===  LABELS  ===
    
    var labelX:CGFloat = 50
    
    var labelWidth:CGFloat {return self.view.frame.width - self.labelX * 2}
    
    var labelMargin:CGFloat { UIScreen.main.bounds.height * 0.022 }
    
    lazy var questionLabel:UILabel = {
        print(UIScreen.main.bounds.height)
        
        let _label = UILabel()
        
        let height:CGFloat = 60
        
        let y = self.answerLabel.frame.origin.y - height
        
        _label.lineBreakMode = .byTruncatingTail
        
        _label.numberOfLines = 2
        
        _label.adjustsFontSizeToFitWidth = true
        
        _label.frame = CGRect(x: self.labelX, y: y, width: self.labelWidth, height: height)
        
        self.setProperties(forLabel:_label, color: UIColor.TextPrimary, font: UIFont.CardQuestion)
        
        return _label
    }()
    
    lazy var answerLabel:UILabel = {
    
        let _label = UILabel()
       
        let height:CGFloat = 40
        let y = self.speakButton.frame.origin.y - self.labelMargin - height
        
        _label.frame = CGRect(x: self.labelX, y: y, width: self.labelWidth, height: height)
        
        self.setProperties(forLabel:_label, color: UIColor.TextSecondary, font: UIFont.CardAnswer)
        
        return _label
        
    }()
    
    lazy var resultLabel:UILabel = {
        
        let _label = UILabel()
        
        let height:CGFloat = 40
        
        let y = self.speakButton.frame.origin.y + self.speakButton.frame.height + self.labelMargin
        
        _label.frame = CGRect(x: self.labelX, y: y, width: self.labelWidth, height: height)
        
        self.setProperties(forLabel:_label, color: UIColor.TextSecondary, font: UIFont.CardAnswer)
        
        return _label
        
    }()
    
    
    //MARK: - ===  BUTTONS  ===
    lazy var speakButton:AnswerButtonView = {
        let _view = AnswerButtonView()
        
        var width = self.view.frame.height * 0.185
        print(width)
        var height = width
        var x = (self.view.frame.width - width) / 2
        var y = (self.view.frame.height - height) / 2
        
        if UIScreen.main.bounds.height < 700 {
            y -= 5
        }
        
        _view.frame = CGRect(x: x, y: y, width: width, height: height)
        
        _view.delegate = self
        
        return _view
    }()
    
    lazy var nextButton:IconFlatButton = {
    
        let _view = IconFlatButton()
    
        let height:CGFloat = 40
        let width = height * 3
        
        _view.frame = CGRect(x: (self.view.bounds.width - width) / 2, y: self.ratingView.frame.origin.y + self.ratingView.bounds.height + 20, width: width, height: height)
        
        _view.construct(title: "NEXT", font: UIFont.NextButton, image: UIImage.NextArrow, bkgColor: UIColor.NextButtonBkg, textColor: UIColor.NextButtonTxt, onPress: self.nextButtonPressed)
        
        _view.isHidden = true
        
        return _view
    }() //--CONSTRUCT IMAGE
    
     
    
    //MARK: - =============== VARS ===============
    var lesson:Lesson?
    
    var customPracticeCards:List<Card>?
    
    var cardPool:List<Card> { return self.customPracticeCards ?? self.lesson?.cards ?? List<Card>() }
    
    var currentCard:Card?
    var speechRecognizer:SpeechRecognizer!
    var speechSynthesizer:SpeechSynthesizer!
    var lessonTitle:String?
    
    var back = false {
        didSet { self.toggleButtons() }
    }
    
    
    //MARK: - =============== SETUP ===============
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add views
        self.view.addSubview(self.speakButton)
        self.view.addSubview(self.answerLabel)
        self.view.addSubview(self.questionLabel)
        self.view.addSubview(self.resultLabel)
        self.view.addSubview(self.ratingView)
        self.view.addSubview(self.nextButton)
        
        self.setUp()
        self.speechRecognizer = SpeechRecognizer(delegate: self)
        self.speechSynthesizer = SpeechSynthesizer(delegate: self)
        self.showNextCard()
        
    }
    
    //-- For subclass setup --//
    func setUp(){
        self.title = lesson?.name
    }
    
    
    //MARK: - ===  SET UI  ===
    func setProperties(forLabel label:UILabel, color:UIColor, font:UIFont) {
        
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        label.font = font
        label.textColor = color
        
    }
    
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
    func answered(_ answerType:AnswerType) {
        
        self.back = true
        
        guard let card = self.currentCard else {return}
        
        card.timesSeen += 1
        
        if answerType == .incorrect {
            
            card.timesIncorrect += 1
            
            if card.interval > 0 { card.interval -= 1 }
            
        } else if answerType == .correct {
            
            card.interval += 1
            
        }

    }

    
    //MARK: - =============== USER INTERACTION ===============
    
    //-- handle answer button answers based on current state --//
    
    func answerButtonPressed(_ sender: AnswerButtonView) {
        print("pressed")
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
   
    
    func nextButtonPressed() {
        
        self.showNextCard()
        
    }
    
    
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
        
        var answerType:AnswerType = .incorrect
        
        
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
            
            answerType = .correct
            
        } else {
            self.ratingView.currentRating = .bad
        
        }
        
        self.resultLabel.colorPassFail(pass: answerType == .correct, passText: "Correct!", failText: "Incorrect!")
        
        if !self.back { self.answered(answerType) }
                   
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





