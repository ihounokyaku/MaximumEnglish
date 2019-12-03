//
//  TestResultVC.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/26/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

class TestResultVC: UIViewController {

    //MARK: - =============== IBOUTLETS ===============
    
    //MARK: - ===  LABELS  ===
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var passFailLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var lessonLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    //MARK: - =============== VARS ===============
    
    var test:Test?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateFields()
        // Do any additional setup after loading the view.
    }
    
    func populateFields() {

        guard let test = self.test, let lesson = test.lesson else { return }
        self.scoreLabel.text = self.test?.scoreString
        self.scoreLabel.colorPassFail(pass: test.passed)
        self.passFailLabel.colorPassFail(pass: test.passed, passText: "PASSED!", failText: "FAILED!")
        self.levelLabel.text = lesson.level[0].name
        self.lessonLabel.text = lesson.name
        self.dateLabel.text = test.dateStarted.toString(format: .yearMonthDayHourMin)
        self.timeLabel.text = test.timeUsed
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
