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
        UIApplication.shared.isStatusBarHidden = true
        updateButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    // MARK: -  Update Views
    func updateButton() {
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.layer.borderWidth = 1.0
        startButton.layer.cornerRadius = 5
    }
}
