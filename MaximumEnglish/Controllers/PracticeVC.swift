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
    
    
    //MARK: - =============== VIEWS ===============
    
    
    //MARK: - ===  HINTVIEW ===
    
    lazy var hintView:TabView = {
       let _view = TabView()
    
        let width:CGFloat = UIScreen.main.bounds.width * 0.9
        
        let height:CGFloat = width * 0.6
        
        let frame = CGRect(x: 0 - width + 40, y: self.questionLabel.frame.origin.y - 40, width: width, height: height)
        
        _view.frame = frame
        
        _view.construct(bkgColor: UIColor.CardLeftTab, strokeColor: UIColor.CardLeftTabOutline, strokeRadius: 2, image: UIImage.HintImage)
        
        _view.addBottomButtons([self.hintButtonOne, self.hintButtonTwo])
        
        _view.addTitleLabel(text: "Hint")
        
        _view.addDescriptionText(text: self.hintText)
        
        _view.delegate = self
        
        return _view
    }()
    
    lazy var hintButtonOne:UIButton = {
        let _button = UIButton()
        
        _button.setTitle("Edit", for: .normal)
        
        _button.addTarget(self, action: #selector(self.hintButtonOnePressed), for: .touchUpInside)
        
        _button.setTitleColor(UIColor.TextSecondary, for: .normal)
        
        return _button
    }()
    
    lazy var hintButtonTwo:UIButton = {
        let _button = UIButton()
        
        _button.setTitle("Save", for: .normal)
        
        _button.addTarget(self, action: #selector(self.hintButtonTwoPressed), for: .touchUpInside)
        
        _button.isEnabled = false
        
        _button.setTitleColor(UIColor.TextSecondary, for: .normal)
        
        _button.setTitleColor(UIColor.TextDisabled, for: .disabled)
        
        return _button
    }()
    
    //MARK: - ===  NOTESVIEW  ===
    lazy var notesView:TabView = {
       let _view = TabView()
    
        let width:CGFloat = UIScreen.main.bounds.width * 0.9
        
        let height:CGFloat = width * 0.6
        
        _view.frame = CGRect(x: 0 - width + 40, y: self.questionLabel.frame.origin.y - 40 + self.hintView.tabHeight + 10, width: width, height: height)
        
        _view.construct(bkgColor: UIColor.CardLeftTab, strokeColor: UIColor.CardLeftTabOutline, strokeRadius: 2, image: UIImage.DescriptionImage)
        
        _view.addTitleLabel(text: "Description")
        
        _view.addDescriptionText(text: self.notesText)
        
        _view.delegate = self
        
        _view.isHidden = true
        
        return _view
    }()
    
    
     lazy var shieldView:UIView = {
         
         let blurEffect = UIBlurEffect(style: .light)
         
         let _view = UIVisualEffectView(effect: blurEffect)
         
         _view.frame = self.view.bounds
         
         _view.isHidden = true
         
         _view.alpha = 0
     
         return _view
     }()
    
    
    
    //MARK: - =============== VARS ===============
    
    var orderedCards:Results<Card> {
        
        return self.cardPool.sorted(byKeyPath: "privateInterval", ascending: true)
        
    }
    
    var topInterval:Int { self.orderedCards.last?.interval ?? 0 }
    
    var bottomInterval:Int { self.orderedCards.first?.interval ?? 0}
    
    var hintText:String {
        return self.currentCard?.hint ?? "Tap \"Edit\" to add a custom hint for this card."
    }
    
    var notesText:String {
        
        if self.currentCard?.notes == nil || self.currentCard?.notes == "" {
            return "No description available."
        }
        
        return self.currentCard!.notes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoView.isHidden = true
        self.speakButton.delegate = self
        self.view.clipsToBounds = true
        
        
        self.view.addSubview(self.shieldView)
        self.view.addSubview(self.notesView)
        self.view.addSubview(self.hintView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    override func toggleButtons() {
        super.toggleButtons()
        self.infoButton.isHidden = !self.back
        self.notesView.isHidden = !self.back
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
    
    override func showNextCard() {
        super.showNextCard()
        
        self.hintView.descriptionText?.text = self.hintText
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
    
    
    
    override func cancelAction() { self.dismiss(animated: true, completion: nil) }
    
    override func playedCorrectAnswer() { self.speakButton.currentState = .tryAgain }
    
    
    //MARK: - =============== HINT BUTTONS ===============
    

    
    @objc func hintButtonOnePressed(_ sender:UIButton) {
        guard let desc = self.hintView.descriptionText else {return}
        if !desc.isEditable {
            
            desc.isEditable = true
            desc.becomeFirstResponder()
            desc.selectAll(nil)
            sender.setTitle("Cancel", for: .normal)
            self.hintButtonTwo.isEnabled = true
            
        } else {
            
            self.endHintEdit()
            
        }
        
    }
    
    @objc func hintButtonTwoPressed(_ sender:UIButton) {
        guard let desc = self.hintView.descriptionText, let card = self.currentCard else {return}
    
        card.hint = desc.text
        
        self.endHintEdit()
        
    }
    
    func endHintEdit() {
        guard let desc = self.hintView.descriptionText else {return}
        desc.text = self.hintText
        self.hintButtonOne.setTitle("Edit", for: .normal)
        desc.isEditable = false
        self.hintButtonTwo.isEnabled = false
    }

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

extension PracticeVC:TabViewDelegate {
    
    
    func tabViewWillOpen(_ tabView: TabView) {
        
        UIView.animate(withDuration: self.hintView.animationDuration) {
            self.shieldView.isHidden = false
            self.shieldView.alpha = 0.7
        }
    }
    
    func tabViewWillClose(_ tabView: TabView) {
        
        self.endHintEdit()
        
        UIView.animate(withDuration: self.hintView.animationDuration, animations: {
            self.shieldView.alpha = 0
        }) { (complete) in
            self.shieldView.isHidden = true
        }
    }
    
    
}



