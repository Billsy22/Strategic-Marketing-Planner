//
//  SplashScreenViewController.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 4/4/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    // MARK: -  Properties
//    let startButton = UIButton()
    @IBOutlet weak var startButton: UIButton!
    
    
    // MARK: -  LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton()
    }
    
    // MARK: -  Update Views
    func updateButton() {
//        startButton.translatesAutoresizingMaskIntoConstraints = false
//        switch Devices.currentDevice {
//        case .iPadPro9Inch, .otheriPad:
//            NSLayoutConstraint(item: startButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 274).isActive = true
//            NSLayoutConstraint(item: startButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 273).isActive = true
//        case .iPadPro10Inch:
//            NSLayoutConstraint(item: startButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailingMargin, multiplier: 1, constant: 275).isActive = true
//            NSLayoutConstraint(item: startButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 200).isActive = true
//        case .iPadPro12Inch:
//            NSLayoutConstraint(item: startButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailingMargin, multiplier: 1, constant: 275).isActive = true
//            NSLayoutConstraint(item: startButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 200).isActive = true
//        default:
//            break
//        }
//        startButton.setTitle("START", for: .normal)
//        startButton.setTitleColor(.white, for: .normal)
//        startButton.titleLabel?.font = UIFont(name: "Arial Hebrew Bold", size: 25.0)
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.layer.borderWidth = 1.0
        startButton.layer.cornerRadius = 5
//        startButton.contentEdgeInsets.left = 30
//        startButton.contentEdgeInsets.right = 30
//        startButton.contentEdgeInsets.top = 8
    }
}
