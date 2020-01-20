//
//  AnswerButtonView.swift
//  MaximumEnglish
//
//  Created by Dylan Southard on 1/15/20.
//  Copyright © 2020 Dylan Southard. All rights reserved.
//

import UIKit

protocol AnswerButtonDelegate {
    
    func answerButtonPressed(_ sender:AnswerButtonView)
    
}

enum AnswerButtonState:String, CaseIterable {
    
    case answer = "Speak Answer"
    case listen = "Listen"
    case listening = ""
    case speaking = "Stop"
    case processing = "Processing"
    case tryAgain = "Try Again"
    case finish = "Finish"
    
}

class AnswerButtonView: UIView {
    
    //MARK: - =============== SUBVIEWS ===============
    
    lazy var button:UIButton = {
        let _button = UIButton(frame: self.bounds)
        
        _button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
        
        return _button
        
    }()
    
    lazy var animationView:PulseView = {
        
        let _view = PulseView()
        _view.backgroundColor = UIColor.clear
        _view.frame = self.bounds
        
        return _view
        
    }()
    
    lazy var imageView: UIImageView = {
        let width = self.bounds.width / 2
        let height = self.bounds.height / 2
        
        let _view = UIImageView(frame: CGRect(x: (self.bounds.width - width) / 2, y: (self.bounds.height - height) / 2, width: width, height: height))
        
        _view.image = UIImage.AnswerButton(for: self.currentState)
        
        _view.contentMode = .scaleAspectFit
        _view.tintColor = UIColor.SpeakBtnImage
        
        return _view
        
    }()
    
    //MARK: - =============== VARS ===============
    
    var delegate:AnswerButtonDelegate?
    
    var currentState:AnswerButtonState = .answer {
        didSet {
            self.imageView.image = UIImage.AnswerButton(for: self.currentState)
            self.animateView(forState: self.currentState)
            
        }
    }
    
    
    //MARK: - =============== SETUP ===============
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.SpeakBtnBkg
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.SpeakBtnBkg
    }
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.SpeakBtnOutline.cgColor
        self.clipsToBounds = true
        self.setUpView()
        
    }
    
    
    func setUpView() {
        
        self.addSubview(self.animationView)
        self.addSubview(self.imageView)
        self.addSubview(self.button)
    }
    
    func animateView(forState state:AnswerButtonState) {
        
        switch state {
            
        case .speaking, .listening:
            
            self.backgroundColor = UIColor.SpeakBtnBkg
            
            self.animationView.animate(withColor: UIColor.Primary(), reverse: false)
            
        case .processing:
            
            self.backgroundColor = UIColor.clear
            
            self.animationView.animate(withColor: UIColor.Secondary(), reverse: true)
            
        default:
            self.backgroundColor = UIColor.SpeakBtnBkg
            self.animationView.stopAnimation(startNew: false)
        }
        
    }
    
    @objc func buttonPressed(_ sender:UIButton) {
        print("def pressed")
        self.delegate?.answerButtonPressed(self)
        
    }
    
    
}
