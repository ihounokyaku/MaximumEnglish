//
//  LessonViewController.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/7/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController {

    //MARK: - =============== IBOUTLETS ===============
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - =============== VARS ===============
    var level:Level?
    var selectedLesson:Lesson?
    
    //MARK: - =============== SETUP ===============
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? SingleLessonVC {
            vc.lesson = self.selectedLesson
        }
        
    }

}

extension LessonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.level?.lessons.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        guard let lesson = level?.lessons[indexPath.row] else { return cell }
        
        cell.textLabel?.text = lesson.name
        
        if lesson.locked {
            cell.textLabel!.text! += "  (locked)"
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedLesson = self.level?.lessons[indexPath.row]
        
        self.performSegue(withIdentifier: "ShowMode", sender: self)
        
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        guard let lesson = level?.lessons[indexPath.row], !lesson.locked else { return nil }
        
        return indexPath
    }
    
    
    
    
    
}
