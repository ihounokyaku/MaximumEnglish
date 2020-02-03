//
//  TestListVC.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/26/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit
import RealmSwift

protocol testViewDelegate { func returnedFromTestView() }

class TestListVC: UIViewController {
    
    @IBOutlet weak var tableView: StyledTableView!
    
   
    
    var lesson:Lesson?
    var selectedTest:Test?
    
    
    var tests:List<Test> {
        let tests = List<Test>()
        
        if let lesson = self.lesson {
                    
            for test in lesson.tests.sorted(byKeyPath: "dateFinished", ascending: true) { tests.append(test) }
            
        }
        
        return tests
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.addSubview(FooterView())
        
        self.title = self.lesson?.name
        
        self.tableView.setUp(delegate: self)
        
        self.tableView.register(UINib(nibName: "TestViewCell", bundle: nil), forCellReuseIdentifier: "TestCell")

    }
    



    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? TestResultVC {
            
            vc.test = self.selectedTest
            
        }
        
    }
   

}

extension TestListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.tests.count)
        return self.tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell") as! TestViewCell
        
        let test = self.tests[indexPath.row]
        
        if let dateFinished = test.dateFinished {
            
            let text = "Date: " + dateFinished.toString(format: .yearMonthDayHourMin) + "    Score: " + "\(test.score)/\(test.cards.count)"
            
            cell.pass = test.passed
            
            cell.style(forRow: indexPath.row)
            
            cell.textLabel?.text = text
            
            
            
        } 
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedTest = self.tests[indexPath.row]
        self.performSegue(withIdentifier: "ToSingleTestResult", sender: self)
        
    }
    
}
