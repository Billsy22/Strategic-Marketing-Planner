//
//  NextStepsViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 4/3/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class NextStepsViewController: UIViewController, PriceLabelable {
    var client: Client? = ClientController.shared.currentClient
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatHeaderLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTotalPriceLabel()
    }
    
    func formatHeaderLabel() {
        headerLabel.textColor = .brandOrange
        headerLabel.text = "Congratulations!"
    }
    
//    func formatTotalPriceLabel() {
//        totalPriceLabel.text = "$0/$5000"
//    }
}
