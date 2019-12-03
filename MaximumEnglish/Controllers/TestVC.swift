//
//  TestVC.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/16/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

class TestVC: CardVC {
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    
    
    var test:Test!
    var interval = -1
    var finish = false
    
    //MARK: - =============== SETUP ===============
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setUp() {
        guard let lesson = self.lesson else { return }
        self.test = lesson.createTest()
    }
    
    
    //MARK: - =============== CARD STUFF ===============
    
    //MARK: - ===  GET CARD  ===
    
    override func getNextCard() -> Card? {
        self.interval += 1
         
        guard self.interval < self.test.cards.count else {
            self.finishAndDisplayScore()
            return nil
        }
        self.questionNumberLabel.text = "Question \(self.interval + 1)/\(self.test.cards.count)"
        return self.test.cards[self.interval]
    }
    
    //MARK: - ===  HANDLE ANSWER  ===

    override func answered(_ answerType: AnserType) {
        
        super.answered(answerType)
        
        guard let card = self.currentCard else { return }
        if self.interval >= self.test.cards.count - 1 {
            self.nextButton.setTitle("Finish", for: .normal)
        }
        self.test.markAnswer(forCard: card, correct: answerType == .correct)
        
    }
    
    
    
    //MARK: - ===  Finish  ===
    
    func finishAndDisplayScore() {
        
        self.nextButton.isEnabled = false
        
        self.test.finish()
        
        self.questionLabel.colorPassFail(pass: self.test.passed, passText: "Passed!", failText: "Failed!")

        self.answerLabel.text = "\(self.test.score)/\(self.test.cards.count)"
        
        self.resultLabel.isHidden = true
        
        self.nextButton.isHidden = true
        
        self.speakButton.currentState = .finish
        
    }
    
    override func finishPressed() { self.dismiss(animated: true, completion: nil) }
    
    override func cancelAction() {
        AlertManager.GetUserConfirmation(forAction: self.finishPressed, alertTitle: "Giving up so soon?", AlertMessage: "Your progress will not be saved!", confirmText: "Give up", cancelText: "Keep trying")
    }
}