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
    
    @IBOutlet weak var levelC: UILabel!
    @IBOutlet weak var lessonC: UILabel!
    @IBOutlet weak var dateC: UILabel!
    @IBOutlet weak var timeC: UILabel!
    
    
    
    //MARK: - =============== VARS ===============
    
    lazy var shieldView:ShieldView = {
        
        let _view = ShieldView(effect: ShieldBlur)
        
        _view.frame = self.view.bounds
        
        _view.delegate = self
        
        return _view
    }()
    
    lazy var cardInfoView:CardInfoView = {
        let _view = CardInfoView()
        
        _view.frame = CGRect(x: 0, y: self.view.bounds.height - _view.visibleClosedHeight, width: UIScreen.main.bounds.width, height: 400)
        
        _view.fullInfo = true
        
        _view.delegate = self
        
        _view.construct()
        
        return _view
    }()
    
    
    var test:Test?
    
    var cards:List<Card> { return self.test?.cards ?? List<Card>()}
    
    var valueLabels:[UILabel] {return [self.levelLabel, self.lessonLabel, self.dateLabel, self.timeLabel] }
    
    var categoryLabels:[UILabel] {return [self.levelC, self.lessonC, self.dateC, self.timeC] }
    
    var headerLabels:[UILabel] {return [self.scoreLabel, self.passFailLabel]}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardTable.delegate = self
        self.cardTable.dataSource = self
        
        self.view.addSubview(FooterView())
        self.view.addSubview(self.shieldView)
        self.view.addSubview(self.cardInfoView)
        
        
        
        self.populateFields()
        
        // Do any additional setup after loading the view.
    }
    
    func styleFields() {
        for label in self.valueLabels {
            
            label.textColor = UIColor.TextPrimary
            
            label.font = UIFont.TestResultValue
            
        }
        
        for label in self.categoryLabels {
            
            label.textColor = UIColor.TextPrimary
            
            label.font  = UIFont.TestResultCategory
        }
        
        for label in headerLabels {
            label.font = UIFont.TestResultHeader
        }
        
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
        
        self.styleFields()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TestViewCell
        
        let card = self.cards[indexPath.row]
        
        if self.test?.answersCorrect.count == self.cards.count {
            cell.accessoryWidthRatio = 1
            cell.passText = "✔︎"
            cell.failText = "✖︎"
            cell.pass = self.test!.answersCorrect[indexPath.row]
            
        }
        
        //        cell.textLabel?.textColor = UIColor.WhitePrimary()
        
        //        cell.contentView.layer.backgroundColor = UIColor.CardListBkg.cgColor
        
        cell.textLabel?.text = "\(indexPath.row + 1).  \(card.question)"
        
        cell.style(forRow: indexPath.row + 1)
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.cardInfoView.populate(fromCard: self.cards[indexPath.row])
        
        self.cardInfoView.animate()
        
    }
    
}

extension TestResultVC : TabViewDelegate, ShieldViewDelegate {
    
    func tabViewWillClose(_ tabView: UIView) {
        
        self.shieldView.hide(withDuration: self.cardInfoView.animationDuration)
    }
    
    func tabViewWillOpen(_ tabView: UIView) {
        
        self.shieldView.show(withDuration: self.cardInfoView.animationDuration)
        
    }
    
    func ShieldViewTapped() {
        
        self.cardInfoView.animate()
        
    }
    
}


