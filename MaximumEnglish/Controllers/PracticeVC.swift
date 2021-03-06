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
    
    
     lazy var shieldView:ShieldView = {
         
         let _view = ShieldView(effect: ShieldBlur)
         
         _view.frame = self.view.bounds
         
        _view.delegate = self
        
         return _view
     }()
    
    //MARK: - ===  INFO VIEW  ===
    
    lazy var cardInfoView:CardInfoView = {
        let _view = CardInfoView()
        
        _view.frame.size = CGSize(width: self.view.bounds.width, height: 300)
        
        _view.frame.origin = CGPoint(x: 0, y: self.view.bounds.height - _view.visibleClosedHeight)
        
        _view.delegate = self
        
        _view.construct()
        
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
        self.speakButton.delegate = self
        self.view.clipsToBounds = true
        
        
        self.view.addSubview(self.shieldView)
        self.view.addSubview(self.notesView)
        self.view.addSubview(self.hintView)
        self.view.addSubview(self.cardInfoView)
        
        
        
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    override func toggleButtons() {
        super.toggleButtons()
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
        
        self.cardInfoView.populate(fromCard: self.currentCard)
        self.hintView.descriptionText?.text = self.hintText
    }
    
    
    //-- handle answers --//
    
    override func answered(_ answerType: AnswerType) {
        super.answered(answerType)
        
        self.cardInfoView.populate(fromCard: self.currentCard)
        
    }
    
    
    override func tryPronunciationAgain() {
 
        self.ratingView.currentRating = nil
        self.speechRecognizer.getSpeech()
        
    }
    
    
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

extension PracticeVC:TabViewDelegate, ShieldViewDelegate {
    
    
    func tabViewWillOpen(_ tabView: UIView) {
        
        self.shieldView.show(withDuration: self.hintView.animationDuration)
        
    }
    
    func tabViewWillClose(_ tabView: UIView) {
        
        self.endHintEdit()
        
        self.shieldView.hide()
    }
    
    func ShieldViewTapped() {
        if self.cardInfoView.open {
            self.cardInfoView.animate()
        }
        
    }
    
    
}



