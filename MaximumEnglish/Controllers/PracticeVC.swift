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


class PracticeVC: CardVC {
    
    //MARK: - =============== INFO OUTLETS ===============
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    
    //MARK: - ===  Labels  ===
    @IBOutlet weak var timesSeenLabel: UILabel!
    @IBOutlet weak var timesCorrectLabel: UILabel!
    @IBOutlet weak var timesIncorrectLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var notesLabel: UITextView!
    
    //MARK: - ===  VIEWS  ===
    
    lazy var hintView:TabView = {
       let _view = TabView()
        
        let width:CGFloat = UIScreen.main.bounds.width * 0.8
        
        let height:CGFloat = width * 0.6
        
        let frame = CGRect(x: 0 - width + 40, y: self.questionLabel.frame.origin.y, width: width, height: height)
        
        _view.frame = frame
        
        _view.construct(bkgColor: UIColor.CardLeftTab, strokeColor: UIColor.CardLeftTabOutline, strokeRadius: 2, image: UIImage.HintImage)
        
        return _view
    }()
    
    var orderedCards:Results<Card> {
        
        return self.cardPool.sorted(byKeyPath: "privateInterval", ascending: true)
        
    }
    
    var topInterval:Int { self.orderedCards.last?.interval ?? 0 }
    
    var bottomInterval:Int { self.orderedCards.first?.interval ?? 0}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoView.isHidden = true
        
        self.view.clipsToBounds = true
        self.view.addSubview(self.hintView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    override func toggleButtons() {
        super.toggleButtons()
        self.infoButton.isHidden = !self.back
    }
    
    
    //MARK: - =============== CARD ACTIONS ===============
    
    override func getNextCard() -> Card? {
        
        let maxInterval = Int.random(in: self.bottomInterval...self.topInterval)
        
        let cardPool = self.cardPool.filter("privateInterval <= %i", maxInterval)
        
        let cardIndex = Int.random(in: 0..<cardPool.count)
        
        guard cardIndex < cardPool.count else {
            print("cardIndex is \(cardIndex), cardpool count is \(cardPool.count)")
            self.currentCard = nil
            return nil
        }
        
        return cardPool[cardIndex]
    }
    
    
    //-- handle answers --//
    
    override func answered(_ answerType: AnserType) {
        super.answered(answerType)
        
        guard let card = self.currentCard else { return }
        
        if answerType == .incorrect && card.interval > 0 {
            
            card.interval -= 1
            
        } else if answerType == .correct {
            
            card.interval += 1
            
        }
        
        card.timesSeen += 1
        
        self.timesSeenLabel.text = "Times Seen: \(card.timesSeen)"
        self.timesCorrectLabel.text = "Times Correct: \(card.timesSeen - card.timesIncorrect)"
        self.timesIncorrectLabel.text = "Times Incorrect \(card.timesIncorrect)"
        self.intervalLabel.text = "Interval: \(card.interval)"
        self.notesLabel.text = card.notes
    }
    
    
    override func tryPronunciationAgain() {
 
        self.ratingView.currentRating = nil
        self.speechRecognizer.getSpeech()
        
    }
    
    @IBAction func infoPressed(_ sender: Any) { self.infoView.isHidden = !self.infoView.isHidden }
    
    @IBAction func hintPressed(_ sender: Any) {
        guard let card = self.currentCard else { return }
        
        AlertManager.PresentEditableTextAlert(title: "Hint", message: "You may create or edit a hint for this card", textFieldText: card.hint ?? "", action: {(str) in
            
            card.hint = str
            
        })
         
    }
    
    override func cancelAction() { self.dismiss(animated: true, completion: nil) }
    
    override func playedCorrectAnswer() { self.speakButton.currentState = .tryAgain }
    
}


extension CALayer {

  func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

    let border = CALayer()

    switch edge {
    case UIRectEdge.top:
        border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)

    case UIRectEdge.bottom:
        border.frame = CGRect(x:0, y: frame.height - thickness, width: frame.width, height:thickness)

    case UIRectEdge.left:
        border.frame = CGRect(x:0, y:0, width: thickness, height: frame.height)

    case UIRectEdge.right:
        border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)

    default: do {}
    }

    border.backgroundColor = color.cgColor

    addSublayer(border)
 }
}



