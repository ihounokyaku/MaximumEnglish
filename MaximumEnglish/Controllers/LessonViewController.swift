//
//  LessonViewController.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/7/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit



class LessonViewController: UIViewController, testViewDelegate {
    
    //MARK: - =============== IBOUTLETS ===============
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - =============== VARS ===============
    var level:Level?
    var selectedLesson:Lesson?
    var pullDownMenuItems:[String] = ["Practice", "Test", "Test Results"]
    
    //MARK: - ===  SECTIONED CONTROLLER  ===
    var expandedSectionHeaderNumber: Int = -1
    var headerTag = 58008
    
    //MARK: - =============== SETUP ===============
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LessonHeaderCell", bundle: Bundle.main)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: LessonHeaderCell.reuseIdentifier!)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.setUI()
    }
    
    func setUI() {
        
        self.title = level?.name
        
    }
    
    
    //MARK: - =============== NAVIGATION ===============
    
    func returnedFromTestView() {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? CardVC {
            
            vc.lesson = self.selectedLesson
            
            if let tvc = vc as? TestVC {
                tvc.delegate = self
            }
            
        } else if let vc = segue.destination as? TestListVC {
            
            vc.lesson = self.selectedLesson
            
        }
        
    }
    
}

//MARK: - =============== TABLEVIEW ===============

extension LessonViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.level?.lessons.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedSectionHeaderNumber == section ? self.pullDownMenuItems.count : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: LessonHeaderCell.reuseIdentifier!) as! LessonHeaderCell
        
        guard let lesson = level?.lessons[section] else { return header }
        
        if let viewWithTag = self.view.viewWithTag(self.headerTag + section) {
            viewWithTag.removeFromSuperview()
        }
        
        header.layer.backgroundColor = section % 2 == 0 ? UIColor.TableOdd.cgColor : UIColor.TableEven.cgColor
        
        header.textLabel?.text = lesson.name
        
        
        header.tag = section
        
        header.addAccessory(locked: lesson.locked, headerHeight: TableRowHeight, rowWidth: self.tableView.frame.width, tag: self.headerTag + section, open: self.expandedSectionHeaderNumber == section)
        
        if !lesson.locked {
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapHeader(_:)))
            
            header.addGestureRecognizer(tapGesture)
            
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableRowHeight
    }
    
    @objc func didTapHeader(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section = headerView.tag
        guard let pmView = headerView.viewWithTag(self.headerTag + section) as? PlusMinusView else { return }
        
        if self.expandedSectionHeaderNumber != -1 && self.expandedSectionHeaderNumber != section {
            
            let expandedPMView = self.view.viewWithTag(self.headerTag + self.expandedSectionHeaderNumber) as! PlusMinusView
            self.expandCollapseSection(self.expandedSectionHeaderNumber, pmView: expandedPMView, expand:false)
            
        }
        
        self.expandCollapseSection(section, pmView: pmView, expand:expandedSectionHeaderNumber != section)
        
    }
    
    func expandCollapseSection(_ section:Int, pmView:PlusMinusView, expand:Bool) {
        
        
        var indexPaths = [IndexPath]()
        for i in 0 ..< self.pullDownMenuItems.count {
            let index = IndexPath(row: i, section: section)
            indexPaths.append(index)
        }
        pmView.animateTransition()
        self.expandedSectionHeaderNumber = expand ? section : -1
        self.tableView.beginUpdates()
        if expand {
            self.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.fade)
        } else {
            self.tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.fade)
        }
        self.tableView.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as! LessonHeaderCell).textLabel!.font = UIFont.TableRowTitle
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = "    " + self.pullDownMenuItems[indexPath.row]
        cell.textLabel?.font = UIFont.TableRowTitle
        cell.textLabel?.textColor = UIColor.TextSecondary
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedLesson = self.level?.lessons[indexPath.section]
        
        self.performSegue(withIdentifier: self.pullDownMenuItems[indexPath.row], sender: self)
        
    }
    

    
    
    
    
}
