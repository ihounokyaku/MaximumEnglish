//
//  TestResultView.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 2/8/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

enum TestResultDetail:String, CaseIterable {
    case level = "Level"
    case lesson = "Lesson"
    case date = "Date"
    case time = "Time"
    
    func label(frame:CGRect)-> UILabel {
        
        let label = UILabel(frame: frame)
        
        label.textColor = UIColor.TestResultCategory
        
        label.text = self.rawValue
        
        label.setFontAdjustedForHeight(font: UIFont.TestResultCategory)
        
        return label
    }
    
    func valueLabel(frame:CGRect, test:Test)->UILabel {
        
        let label = UILabel(frame:frame)
        
        guard let lesson = test.lesson else { return label }
        
        let text:[TestResultDetail:String] = [.level:lesson.level[0].name, .lesson:lesson.name, .date:test.dateStarted.toString(format: .yearMonthDayHourMin), .time:test.timeUsed]
        
        guard let t = text[self] else { return label }
        
        label.text = t
        
        label.textColor = UIColor.TestResultValue
        
        label.setFontAdjustedForHeight(font: UIFont.TestResultValue)
        
        return label
        
    }
    
}

class TestResultView: UIView {


    
    //MARK: - =============== MEASUREMENTS ===============
    
    //MARK: - ===  UNIVERSAL  ===
    
    var verticalMargin:CGFloat = 20
    
    //MARK: - ===  HEADER  ===
    var headerRatio:CGFloat = 0.5
    
    var headerHeight:CGFloat { return self.bounds.height * self.headerRatio }
    
    var headerContentHeight:CGFloat { return self.headerHeight - self.headerBottomMargin }
    
    var headerTopMarginRatio:CGFloat = 1
    
    var headerLabelRatio:CGFloat = 1
    
    var headerBottomMargin:CGFloat = 15
    
    var headerTotalRatio:CGFloat {return self.headerLabelRatio * 2 + self.headerTopMarginRatio}
    
    var headerMarginHeight:CGFloat {return self.headerContentHeight * (self.headerTopMarginRatio / self.headerTotalRatio)}
    
    var headerLabelHeight:CGFloat {return self.headerContentHeight * (self.headerLabelRatio / self.headerTotalRatio)}
    
    
    //MARK: - ===  DETAILS  ===
    
    var detailHeight:CGFloat { return self.bounds.height - self.headerHeight }
    
    var detailMarginRatio:CGFloat = 0.084
    
    var detailMargin:CGFloat {return self.detailHeight * detailMarginRatio}
    
    var totalDetailMarginHeight:CGFloat {return self.detailMargin * CGFloat(TestResultDetail.allCases.count + 1)}
    
    var detailLabelHeight:CGFloat {return (self.detailHeight - self.totalDetailMarginHeight) / CGFloat(TestResultDetail.allCases.count)}
    
    var detailLabelValueMargin:CGFloat = 10
    
    //MARK: - =============== POPULATE LABEL ===============

    func populate(withTest test:Test) {
        
        var currentY = self.headerMarginHeight
        
        // --- HEADER --//
        
        self.addHeaderLabel(withText: test.scoreString, y: currentY, pass:test.passed)
        
        currentY += self.headerLabelHeight
        
        self.addHeaderLabel(withText: test.passed ? "PASSED!" : "FAILED!", y: currentY, pass: test.passed)
        
        currentY = self.headerHeight
        
        //--- DETAILS ---//
    
        for detail in TestResultDetail.allCases {
            
            let titleLabel = detail.label(frame: CGRect(x: self.verticalMargin, y: currentY, width: 40, height: self.detailLabelHeight))
            
            let valueLabel = detail.valueLabel(frame: CGRect(x: self.verticalMargin + titleLabel.bounds.width + self.detailLabelValueMargin, y: currentY, width: 100, height: self.detailLabelHeight), test: test)
            
            self.addSubview(titleLabel)
            self.addSubview(valueLabel)
            
            currentY += (self.detailLabelHeight + detailMargin)
            
        }
        
    }
        
    func addHeaderLabel(withText text:String, y:CGFloat, pass:Bool) {
        
        let label = UILabel(frame: CGRect(x: verticalMargin, y: y, width: self.bounds.width - verticalMargin * 2, height: self.headerLabelHeight))
        
        label.text = text
        
        label.colorPassFail(pass: pass)
        
        label.font = UIFont.TestResultHeader
        
        label.adjustsFontSizeToFitWidth = true
        
        label.textAlignment = .center
        
        self.addSubview(label)
    
    }
    
}

extension UILabel {
    func setFontAdjustedForHeight(font:UIFont) {
        
        self.font = font.withProperSize(forHeight: self.bounds.height)
        self.sizeToFit()
        
    }
}

extension UIFont {
    
    func withProperSize(forHeight height:CGFloat)->UIFont {
        
        var size = self.pointSize
        var font = self
        
        
        while size > height {
            size -= 1
            font = font.withSize(size)
        }
        
        return font

    }
    
}
