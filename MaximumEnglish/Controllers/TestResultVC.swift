//
//  TestResultVC.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/26/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit
import RealmSwift

class TestResultVC: UIViewController {

    //MARK: - =============== IBOUTLETS ===============
    
    @IBOutlet weak var cardTable: UITableView!
    
    //MARK: - ===  LABELS  ===
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var passFailLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var lessonLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    //MARK: - =============== VARS ===============
    
    var test:Test?
    
    var cards:List<Card> { return self.test?.cards ?? List<Card>()}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardTable.delegate = self
        self.cardTable.dataSource = self
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
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? CardViewerVC {
            vc.card = sender as? Card
            
        }
    }
    

}

extension TestResultVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let card = self.cards[indexPath.row]
        if self.test?.answersCorrect.count == self.cards.count {
            cell.textLabel?.colorPassFail(pass: self.test!.answersCorrect[indexPath.row])
        }
        cell.contentView.backgroundColor = UIColor.black
        cell.layer.backgroundColor = indexPath.row % 2 == 0 ? UIColor.TableOdd.cgColor : UIColor.TableEven.cgColor
        cell.contentView.layer.backgroundColor = UIColor.black.cgColor
        
        cell.textLabel?.text = "\(indexPath.row + 1).  \(card.question)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        self.performSegue(withIdentifier: "ToCardViewer", sender: self.cards[indexPath.row])
    }

    
    
    
    
}
