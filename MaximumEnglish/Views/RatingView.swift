//
//  RatingView.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 11/15/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import UIKit

enum Rating:String, CaseIterable {
    
    case bad = "uhoh"
    case soso = "neutral"
    case good = "like"
    case great = "love"
    
    static func ForPercentage(_ percentage:Float)->Rating {
        switch percentage {
            
        case let x where x > 0.8:
            return Rating.great
        case let x where x > 0.6:
            return Rating.good
        case let x where x > 0.4:
            return Rating.soso
        case let x where x < 0.4:
            return Rating.bad
        default:
            return .good
        }
    }
    
}

class RatingView: UIView {
    
    var buffer:CGFloat = 15
    
    var images = [UIImageView]()
    
    var currentRating:Rating? {
        
        didSet{ self.refreshImages() }
        
    }
    
    override init(frame: CGRect) {
        
      super.init(frame: frame)
        print("initializing")
        self.setUpImages()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
        self.setUpImages()
    }
    
    override func updateConstraints() {
        
        super.updateConstraints()
        self.setUpImages()
        
    }
    
    func setUpImages() {
        
        self.removeAllImages()
        
        let imageCount = CGFloat(Rating.allCases.count)
        
        var imageWidth = (self.frame.width - self.buffer * (imageCount + 1)) / imageCount
        
        if imageWidth > self.frame.height {
            
            imageWidth = self.frame.height
            
            self.buffer = (self.frame.width - (imageWidth * imageCount)) / (imageCount + 1)
        }
        
        var x = self.buffer
        
        let y = self.bounds.origin.y + (self.frame.height / 2) - (imageWidth / 2)
        for _ in Rating.allCases {
            
            let imageFrame = CGRect(x: x, y: y, width: imageWidth, height: imageWidth)
            let imageView = UIImageView(frame: imageFrame)
            self.images.append(imageView)
            self.addSubview(imageView)
            x += (imageWidth + self.buffer)
            
        }
        
        self.refreshImages()
        
    }
    
    func removeAllImages() {
        
        for image in self.images {
            image.removeFromSuperview()
        }
        
        self.images.removeAll()
        
    }
    
    func refreshImages() {
        for (i, view) in self.images.enumerated() {
            guard i < Rating.allCases.count else { return }
            
            let rating = Rating.allCases[i]
            
            var imageName = rating.rawValue
            
            if rating == self.currentRating {
                
                imageName += "-fill"
                
            }
            
            imageName += ".png"
            
            view.image = UIImage(named: imageName)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
