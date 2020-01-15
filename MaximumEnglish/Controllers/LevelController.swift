//
//  ViewController.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2019/10/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit
import SVProgressHUD

class LevelController: UIViewController {

    //MARK: - =============== IBOUTLETS ===============
    
    @IBOutlet weak var tableView: UITableView!
    
    var checkedForUpdates = false
    
    var selectedLevel:Level?
    
    
    //MARK: - =============== SETUP ===============
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.styleNavBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.checkedForUpdates == false {
            self.checkedForUpdates = true
            self.checkForUpdates()
        }
        
        
    }
    
    func styleNavBar() {
         
        self.navigationController?.navigationBar.barTintColor = UIColor.NavMenuBkg
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.NavBarTitle]
        
        self.navigationController?.navigationBar.tintColor = UIColor.NavMenuBtn
        
    }
    
    func checkForUpdates() {
        
        SVProgressHUD.show(withStatus: "Checking for updates...")
        
        let populator = DataPopulator()
        
        populator.delegate = self
        
        populator.executeUpdateQuery()
        
    }
    
    //MARK: - =============== NAVIGATION ===============

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let vc = segue.destination as? LessonViewController {

            vc.level = self.selectedLevel }
        
    }

}


//MARK: - =============== TABLEVIEW ===============

extension LevelController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.Levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = LevelName.allCases[indexPath.row].rawValue
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedLevel = DataManager.Levels[indexPath.row]
        
        self.performSegue(withIdentifier: "ShowLessons", sender: self)
    }

}

extension LevelController:DataPopulatorDelegate {
    func dataUpdateComplete(withError error: String?) {
        if let realError = error { print(realError) }
        SVProgressHUD.dismiss()
    }
    
    
    
}

