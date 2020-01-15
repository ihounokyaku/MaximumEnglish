//
//  CardViewerVC.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 12/16/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

class CardViewerVC: UIViewController {
    
    //MARK: - =============== IBOUTLETS ===============
    
    //MARK: - ===  LABELS/TEXTVIEWS ===
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var timesSeenLabel: UILabel!
    @IBOutlet weak var timesCorrectLabel: UILabel!
    @IBOutlet weak var timesIncorrectLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var explanationTextBox: UITextView!
    
    //MARK: - ===  BUTTONS  ===
    
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: - =============== VARS ===============
    
    var card:Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateFields()
        // Do any additional setup after loading the view.
    }
    
    
    func populateFields() {
        guard let card = self.card else { return }
        self.questionLabel.text = card.question
        self.answerLabel.text = card.answer
        self.timesSeenLabel.text = "Times Seen: \(card.timesSeen)"
        self.timesCorrectLabel.text = "Times Correct: \(card.timesSeen - card.timesIncorrect)"
        self.timesIncorrectLabel.text = "Times Incorrect \(card.timesIncorrect)"
        self.intervalLabel.text = "Interval: \(card.interval)"
        self.explanationTextBox.text = card.notes
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
