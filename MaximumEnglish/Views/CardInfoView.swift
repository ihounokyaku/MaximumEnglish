//
//  CardInfoView.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 1/21/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//
enum CardInfoItem:String, CaseIterable {
    case timesSeen = "Times Seen:"
    case timesCorrect = "Times Correct:"
    case timesIncorrect = "Times Incorrect:"
    case interval = "Interval:"
    
}



import UIKit

class CardInfoView: UIView {
    
    //MARK: - =============== SUBVIEWS ===============
    lazy var topView:UIView = {
        let _view = UIView()
        
        _view.frame = CGRect(x: (self.bounds.width - self.topViewHeight) / 2, y: 0, width: self.topViewHeight, height: self.topViewHeight)
        
        _view.backgroundColor = UIColor.cardInfoViewBkg
        
        _view.layer.cornerRadius = self.topViewHeight / 2
        
        _view.clipsToBounds = true
        
        return _view
    }()
    
    lazy var mainView:UIView = {
        let _view = UIView()
        
        _view.frame = CGRect(x: 0, y: self.topViewVisibileHeight, width: self.bounds.width, height: self.bounds.height - self.topViewVisibileHeight)
        
        _view.backgroundColor = UIColor.cardInfoViewBkg
        
        return _view
    }()
    
    lazy var button:UIButton = {
        
        let _button = UIButton()
        
        _button.frame = CGRect(x: 0, y: 0, width: self.topView.bounds.width, height: self.topViewVisibileHeight)
        
        _button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        
        return _button
    }()
    
    var topImage:UIImageView?
    
    
    //MARK: - =============== LABELS ===============
    var timesSeen = UILabel()
    var timesCorrect = UILabel()
    var timesIncorrect = UILabel()
    var interval:UILabel = UILabel()
    var question:UILabel = UILabel()
    var answer:UILabel = UILabel()
    var explanation:UILabel = UILabel()
    var explanationBox:UITextView = UITextView()
    
    //MARK: - =============== FRAME PARAMS ===============
    
    //MARK: - ===  ALL  ===
    
    var horizontalMargin:CGFloat = 30
    
    var verticalMargin:CGFloat = BottomFrameHeight
    
    var visibleClosedHeight:CGFloat { return self.topViewVisibileHeight + self.verticalMargin }
    
    //MARK: - ===  TOPVIEW  ===
    var topViewItemMargin:CGFloat = 2
    
    var topViewTopMargin:CGFloat = 12
    
    var topViewItemHeight:CGFloat {return (self.topViewVisibileHeight - self.topViewTopMargin - topViewItemMargin * 2) / 3}
    
    var topViewImageWidth:CGFloat {return self.topViewHeight / 10}
    
    var topViewHeight:CGFloat {
        print(UIScreen.main.bounds.height)
        return self.fullInfo ? 0 : self.bounds.width * (UIScreen.main.bounds.height < 700 ? 0.40 : 0.45)}
    
    var topViewVisibileHeight:CGFloat {return self.topViewHeight / 2.8}
    
    var titleValueMargin:CGFloat = 10
    
    
    //MARK: - ===  HEADER  ===
    
    var headerRatio:CGFloat = 0.5
    
    var headerHeight:CGFloat {return self.fullInfo ? self.bounds.height * headerRatio : 0}
    
    var headerItemMargin:CGFloat = 0
    
    var freeHeaderSpace:CGFloat {return (self.headerHeight - self.labelHeight - self.headerItemMargin * 2) - self.headerBottomMargin - self.dividerHeight}
    
    var headerLabelHeight:CGFloat {return self.freeHeaderSpace * (self.headerLabelRatio / self.headerItemTotalRatio)}
    
    var headerTextBoxHeight:CGFloat {return self.freeHeaderSpace * (self.headerTextBoxRatio / self.headerItemTotalRatio)}
    
    var headerLabelRatio:CGFloat = 1
    
    var headerTextBoxRatio:CGFloat = 2
    
    var headerItemTotalRatio:CGFloat { return self.headerLabelRatio * 2 + headerTextBoxRatio }
    
    var dividerHeight:CGFloat = 1
    
    var headerBottomMargin:CGFloat = 10
    
    //MARK: - ===  INFO LABELS  ===
    
    var labelHeight:CGFloat { return (self.mainView.bounds.height - self.headerHeight - self.verticalMargin * 2) / CGFloat(CardInfoItem.allCases.count) }
    
    
    
    //MARK: - =============== STATE VARS ===============
    var open = false
    var animating = false
    
    
    //MARK: - =============== OTHER VARS ===============
    var animationDuration:Double = 0.3
    var delegate:TabViewDelegate?
    var fullInfo = false
    //MARK: - =============== SETUP ===============
    
    func construct() {
        
        self.addSubview(self.topView)
        self.addSubview(self.mainView)
        self.backgroundColor = UIColor.clear
        
        // -- ADD LABELS --//
        var currentLabelY = self.verticalMargin
        
        if self.fullInfo {
            
            // Add Headers
            
            for label in [self.question, self.answer] {
                
                label.font = UIFont.CardInfoHeader
                
                label.textAlignment = .center
                
                label.textColor = UIColor.CardInfoHeaderText
                
                label.adjustsFontSizeToFitWidth = true
                
                label.frame = CGRect(x: self.horizontalMargin, y: currentLabelY, width: self.bounds.width - self.horizontalMargin * 2, height: self.headerLabelHeight)
                
                self.addSubview(label)
                
                currentLabelY += label.bounds.height + self.headerItemMargin
            }
            
            //Add explanation title
            
            let explanationTitle = self.addTitleLabel(withText: "Explanation:", yValue: currentLabelY)
            
            currentLabelY += explanationTitle.bounds.height
            
            // Add explanation textbox
            self.explanationBox.frame = CGRect(x: self.horizontalMargin, y: currentLabelY, width: self.bounds.width - self.horizontalMargin * 2, height: self.headerTextBoxHeight)
            
            self.explanationBox.isScrollEnabled = true
            
            self.explanationBox.isEditable = false
            
            self.explanationBox.font = UIFont.CardInfoTextBox
            
            self.explanationBox.textColor = UIColor.CardInfoTextBoxText
            
            self.explanationBox.backgroundColor = UIColor.CardInfoTextBoxBkg
            
            self.addSubview(self.explanationBox)
            
            currentLabelY += (self.explanationBox.bounds.height + self.headerBottomMargin / 2)
            
            //ADD DIVIDER AND MARGIN
            
            let divider = UIView(frame: CGRect(x: self.verticalMargin, y: currentLabelY, width: self.bounds.width - self.verticalMargin * 2, height: self.dividerHeight))
            
            divider.backgroundColor = UIColor.CardInfoDivider
            
            self.addSubview(divider)
            
            currentLabelY += divider.bounds.height + self.headerBottomMargin / 2
        }
        
        
        for item in CardInfoItem.allCases {
            
            let titleLabel = self.addTitleLabel(withText: item.rawValue, yValue: currentLabelY)
            
            self.mainView.addSubview(titleLabel)
            
            let itemX = self.horizontalMargin + titleLabel.bounds.width + self.titleValueMargin
            
            self.label(forItem: item).frame = CGRect(x: itemX, y: currentLabelY, width: self.mainView.bounds.width - itemX - self.horizontalMargin, height: self.labelHeight)
            
            self.label(forItem: item).textColor = UIColor.cardInfoItemText
            
            self.label(forItem: item).font = UIFont.CardInfoItem
            
            self.mainView.addSubview(self.label(forItem: item))
            
            currentLabelY += self.labelHeight
            
        }
        
        //-- ADD TOPVIEW CONTENT --//
        
        self.topImage = self.topViewImageView(withImage: UIImage.CardInfoTop, yPosition: self.topViewTopMargin)
        self.topView.addSubview(self.topImage!)
        
        self.topView.addSubview(self.topViewImageView(withImage: UIImage.CardInfoBottom, yPosition: self.topViewTopMargin + self.topViewItemHeight + self.topViewItemMargin))
        
        let topText = UILabel()
        topText.textColor = UIColor.cardInfoViewImg
        topText.font = UIFont.CardInfoTopView
        topText.text = "CARD HISTORY"
        topText.sizeToFit()
        
        topText.frame.origin = CGPoint(x: (self.topView.bounds.width - topText.bounds.width) / 2, y: self.topViewVisibileHeight - topText.bounds.height * 0.8)
        
        self.topView.addSubview(topText)
        
        self.topView.addSubview(self.button)
        
        //--ADD GESTURE RECOGNIZERS--//
        self.addGestures(toView: self.button)
        self.addGestures(toView: self.mainView)
    }
    
    func addGestures(toView view:UIView) {
        
        for direction in self.fullInfo ? [UISwipeGestureRecognizer.Direction.down] : [UISwipeGestureRecognizer.Direction.up, UISwipeGestureRecognizer.Direction.down] {
            
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_:)))
            
            swipe.direction = direction
            
            view.addGestureRecognizer(swipe)
            
        }
    }
    
    func addTitleLabel(withText text:String, yValue:CGFloat)-> UILabel {
        
        let titleLabel = UILabel(frame: CGRect(x: self.horizontalMargin, y: yValue, width: 0, height: self.labelHeight))
        
        titleLabel.text = text
        
        titleLabel.font = UIFont.CardInfoCategory
        
        titleLabel.sizeToFit()
        
        titleLabel.frame.size = CGSize(width: titleLabel.frame.width, height: self.labelHeight)
        
        titleLabel.textColor = UIColor.cardInfoCategoryText
        
        self.mainView.addSubview(titleLabel)
        
        return titleLabel
        
    }
    
    func topViewImageView(withImage image:UIImage, yPosition:CGFloat)->UIImageView {
        let imageView = UIImageView(image:image.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = UIColor.cardInfoViewImg
        imageView.contentMode = .scaleAspectFit
        
        imageView.frame = CGRect(x: (self.topView.bounds.width - self.topViewImageWidth) / 2, y: yPosition, width: self.topViewImageWidth, height: self.topViewItemHeight)
        
        return imageView
        
    }
    
    func label(forItem item:CardInfoItem)->UILabel {
        switch item {
            
        case .interval:
            return self.interval
        case .timesCorrect:
            return self.timesCorrect
        case .timesIncorrect:
            return self.timesIncorrect
        case .timesSeen:
            return self.timesSeen
        }
    }
    
    
    //MARK: - =============== OPEN CLOSE ===============
    
    @objc func buttonPressed() {
        self.animate()
    }
    
    @objc func swiped(_ sender:UIGestureRecognizer) {
        guard let gesture = sender as? UISwipeGestureRecognizer, self.open == (gesture.direction == .down) else {return}
        self.animate()
    }
    
    func animate() {
        guard self.animating == false else { return }
        
        if self.open {
            
            self.delegate?.tabViewWillClose(self)
            
        } else {
            
            self.delegate?.tabViewWillOpen(self)
            
        }
        
        self.animating = true
        
        UIView.animate(withDuration: self.animationDuration, animations: {
            
            self.topImage?.transform = CGAffineTransform(rotationAngle: self.open ? 0 : CGFloat(180).radiansToDegrees())
            self.transform = CGAffineTransform(translationX: 0, y:  self.open ? 0 : -(self.frame.height - self.visibleClosedHeight))
            
            self.button.isUserInteractionEnabled = false
            
        }) { (complete) in
            
            self.animating = false
            
            self.open = !self.open
            
            self.button.isUserInteractionEnabled = true
            
        }
    }
    
    //MARK: - =============== POPULATE VALUES ===============
    func populate(fromCard optCard:Card?) {
        
        guard let card = optCard else {return}
        
        self.timesSeen.text = "\(card.timesSeen)"
        self.timesCorrect.text = "\(card.timesSeen - card.timesIncorrect)"
        self.timesIncorrect.text = "\(card.timesIncorrect)"
        self.interval.text = "\(card.interval)"
        
        guard self.fullInfo else { return }
        
        self.question.text = card.question
        self.answer.text = card.answer
        self.explanationBox.text = card.notes != "" ? card.notes : "No explanation available"
        
    }
    
}
