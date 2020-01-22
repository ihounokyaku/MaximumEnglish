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
    
    //MARK: - =============== FRAME PARAMS ===============
    
    var topViewItemMargin:CGFloat = 2
    
    var topViewTopMargin:CGFloat = 12
    
    var topViewItemHeight:CGFloat {return (self.topViewVisibileHeight - self.topViewTopMargin - topViewItemMargin * 2) / 3}
    
    var topViewImageWidth:CGFloat {return self.topViewHeight / 10}
    
    var topViewHeight:CGFloat {return self.bounds.width * 0.45}
    
    var horizontalMargin:CGFloat = 30
    
    var verticalMargin:CGFloat = 30
    
    var titleValueMargin:CGFloat = 10
    
    var topViewVisibileHeight:CGFloat {return self.topViewHeight / 2.8}
    
    var labelHeight:CGFloat { return (self.mainView.bounds.height - self.verticalMargin * 2) / CGFloat(CardInfoItem.allCases.count) }
    
    var visibleClosedHeight:CGFloat { return self.topViewVisibileHeight + self.verticalMargin }
    
    //MARK: - =============== STATE VARS ===============
    var open = false
    var animating = false
    
    //MARK: - =============== OTHER VARS ===============
    var animationDuration:Double = 0.3
    var delegate:TabViewDelegate?
    //MARK: - =============== SETUP ===============
    
    func construct() {
        
        self.addSubview(self.topView)
        self.addSubview(self.mainView)
        self.backgroundColor = UIColor.clear
        
        // -- ADD LABELS --//
        var currentLabelY = self.verticalMargin
        
        for item in CardInfoItem.allCases {
            
            let titleLabel = UILabel(frame: CGRect(x: self.horizontalMargin, y: currentLabelY, width: 0, height: self.labelHeight))
            
            titleLabel.text = item.rawValue
            
            titleLabel.font = UIFont.CardInfoCategory
            
            titleLabel.sizeToFit()
            
            titleLabel.frame.size = CGSize(width: titleLabel.frame.width, height: self.labelHeight)
            
            titleLabel.textColor = UIColor.cardInfoHeaderText
            
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
        topText.text = "SCORE HISTORY"
        topText.sizeToFit()
        
        topText.frame.origin = CGPoint(x: (self.topView.bounds.width - topText.bounds.width) / 2, y: self.topViewVisibileHeight - topText.bounds.height * 0.8)
        self.topView.addSubview(topText)
        self.topView.addSubview(self.button)
        
        //--ADD GESTURE RECOGNIZERS--//
        self.addGestures(toView: self.button)
        self.addGestures(toView: self.mainView)
    }
    
    func addGestures(toView view:UIView) {
        
        for direction in [UISwipeGestureRecognizer.Direction.up, UISwipeGestureRecognizer.Direction.down] {
            
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_:)))
            
            swipe.direction = direction
            
            view.addGestureRecognizer(swipe)
            
        }
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
   

}
