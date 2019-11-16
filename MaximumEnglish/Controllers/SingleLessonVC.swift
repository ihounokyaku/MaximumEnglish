//
//  SingleLessonVC.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/7/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

class SingleLessonVC: UIViewController {

    //MARK: - =============== IBOUTLETS ===============
    
    @IBOutlet weak var practiceButton: UIButton!
    @IBOutlet weak var testButton: UIButton!
    
    //MARK: - =============== VARS ===============
    var lesson:Lesson?
    
    //MARK: - =============== SETUP ===============
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PracticeVC {
            vc.lesson = self.lesson
        }
    }
    
    
    
    //MARK: - =============== NAVIGATION ===============
    @IBAction func practicePressed(_ sender: Any) {
        
        
    }
    
    @IBAction func testPressed(_ sender: Any) {
        
        
    }
    
}
