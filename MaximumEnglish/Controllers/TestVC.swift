//
//  TestVC.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/16/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

class TestVC: CardVC {
    
    
    //MARK: - =============== QUESTION NO ===============
    lazy var questionNumberLabel:UILabel = {
        let _label = UILabel()
        
        _label.frame = CGRect(x: 30, y: self.navBarHeight + 20, width: self.view.bounds.width - 60, height: 40)
        
        _label.textAlignment = .center
        
        _label.textColor = UIColor.QuestionNumber
        
        _label.font = UIFont.QuestionNumber
        
        return _label
    }()
    
    //MARK: - =============== VARS ===============
    var test:Test!
    var interval = -1
    var finish = false
    var delegate:testViewDelegate?
    
    //MARK: - =============== SETUP ===============
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
   
    
    override func setUp() {
        
        super.setUp()
        
        self.view.addSubview(self.questionNumberLabel)
        
        self.view.addSubview(FooterView())
        
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
            
            self.nextButton.label?.text = "Finish"
            
        }
        
        self.test.markAnswer(forCard: card, correct: answerType == .correct)
        
    }
    
    
    
    //MARK: - ===  Finish  ===
    
    func finishAndDisplayScore() {
        
        self.nextButton.isEnabled = false
        
        self.test.finish()
        
        self.performSegue(withIdentifier: "toResult", sender: self.test)
        
    }
    
    override func finishPressed() { self.dismiss(animated: true, completion: delegate?.returnedFromTestView) }
    
    
    
    override func cancelAction() {
        AlertManager.GetUserConfirmation(forAction: self.finishPressed, alertTitle: "Giving up so soon?", AlertMessage: "Your progress will not be saved!", confirmText: "Give up", cancelText: "Keep trying")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? TestResultVC, let test = sender as? Test {
            
            vc.test = test
            vc.delegate = delegate
            let backItem = UIBarButtonItem()
            backItem.title = self.lessonTitle
            navigationItem.backBarButtonItem = backItem
        }
        
    }
}
