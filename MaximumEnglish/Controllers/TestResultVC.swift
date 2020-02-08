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
    
    
    //MARK: - =============== VARS ===============
    
    var tableHeight:CGFloat {return UIScreen.main.bounds.height > 700 ? 326 : self.viewHeight / 2 - 30}
    
    var viewHeight:CGFloat {return self.view.bounds.height - self.navBarHeight}
    
    lazy var resultView:TestResultView = {
        
        let _view = TestResultView(frame: CGRect(x: 0, y: self.navBarHeight, width: UIScreen.main.bounds.width, height: self.viewHeight - self.tableHeight - BottomFrameHeight))
        
        if let test = self.test {_view.populate(withTest: test)}
        
        return _view
    }()
    
    lazy var cardTable:UITableView = {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: self.resultView.bounds.height + self.navBarHeight, width: UIScreen.main.bounds.width, height: self.tableHeight))
        
        tableView.register(TestViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
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
    
    
    var delegate:testViewDelegate?
    
    
    //MARK: - =============== SETUP ===============
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.resultView)
        self.view.addSubview(self.cardTable)
        self.view.addSubview(FooterView())
        self.view.addSubview(self.shieldView)
        self.view.addSubview(self.cardInfoView)
        
        self.title = "Results"
        
        self.removeTestVCIfNecessary()

    }
    
   
    
    //MARK: - ===  HANDLE RETURN TO LESSON  ===
    
    func removeTestVCIfNecessary() {
        
        guard let navController = navigationController else {return}
        
        let viewControllerCount = navController.viewControllers.count
        
        guard viewControllerCount > 2, let _ = navController.viewControllers[viewControllerCount - 2] as? TestVC else {return}
        
        navController.viewControllers.remove(at: viewControllerCount - 2)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.returnedFromTestView()
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


