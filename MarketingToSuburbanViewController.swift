//
//  MarketingToSuburbanViewController.swift
//  Strategic Marketing Planner
//
//  Created by cruizthomason on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class MarketingToSuburbanViewController: UIViewController {

    @IBOutlet weak var zeroLabel: UILabel!
    @IBOutlet weak var thousandLabel: UILabel!
    @IBOutlet weak var twoThousandLabel: UILabel!
    @IBOutlet weak var threeThousandLabel: UILabel!
    @IBOutlet weak var fourThousandLabel: UILabel!
    @IBOutlet weak var fiveThousandLabel: UILabel!
    @IBOutlet weak var sixThousandLabel: UILabel!
    @IBOutlet weak var sevenThousandLabel: UILabel!
    @IBOutlet weak var perMonthLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var pricePerMonthSlider: UISlider!
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func sliderValueSelected(_ sender: UISlider) {

        pricePerMonthSlider.value = roundf(pricePerMonthSlider.value)
        var priceArray = ["$0", "$1000", "$2000", "$3000", "$4000", "$5000", "$6000", "$7000"]
        let currentValue = priceArray[Int(sender.value)]
        perMonthLabel.text = "\(currentValue)"
        totalPriceLabel.text = "\(currentValue) / $5000"
    
    }
    
}

