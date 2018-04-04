//
//  ExternalMarketingViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 4/4/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ExternalMarketingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let client = Client(firstName: "Mike", lastName: "Jones", practiceName: "Mike's Dental", phone: "801-223-2332", email: "mike@jones.com", address: "123", city: "SLC", state: "UT", zip: "84059", initialContact: Date())
    
    let clientController = ClientController.shared
    
    let marketingOptions = ["Urban", "Suburban", "Rural"]
    let marketingOptionSummaries = ["A digital marketing focus. Ideal for highly populated areas.", "A mix of digital and traditional marketing to maximize results in a suburban demographic.", "A traditional marketing focus. Ideal for rural areas."]
    
    let urbanPrices = ["0", "750", "1750", "2750", "3750", "4750"]
    let suburbanPrices = ["0", "1000", "1500", "2000", "2500", "3000", "3500", "4000", "4500", "5000", "5500", "6000", "6500"]
    let ruralPrices = ["0", "500", "1000", "1500", "2000", "2500", "3000", "3500", "4000", "5000", "6000"]
    
    let marketingToUrban = "Move the slider to select an external marketing budget for Urban/Digital marketing. Below are the available monthly payment amounts for a 12 month term."
    let marketingToSuburban = "Move the slider to select an external marketing budget for Suburban/Mix of Digital & Traditional marketing. Below are the available monthly payment amounts for a 12 month term."
    let marketingToRural = "Move the slider to select an external marketing budget for Rural/Traditional marketing. Below are the available monthly payment amounts for a 12 month term."
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var marketingMixTableView: UITableView!
    @IBOutlet weak var marketingToLabel: UILabel!
    @IBOutlet weak var pricePerMonthLabel: UILabel!
    @IBOutlet weak var pricePerMonthSlider: UISlider!
    
    @IBAction func sliderValueSelected(_ sender: UISlider) {
        pricePerMonthSlider.value = roundf(pricePerMonthSlider.value)
        let currentValue = suburbanPrices[Int(sender.value)]
        pricePerMonthLabel.text = "$\(currentValue) per month"
        totalPriceLabel.text = "$\(currentValue)/$5000"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatHeader()
        tableViewCustomization()
        formatSlider()
        marketingToLabel.text = marketingToSuburban
    }
    
    func formatSlider() {
        pricePerMonthSlider.maximumValue = Float(suburbanPrices.count - 1)
        pricePerMonthSlider.tintColor = .brandBlue
        pricePerMonthSlider.value = 0
    }
    
    func formatMarketingToLabel() {
        
    }
    
    func tableViewCustomization() {
        marketingMixTableView.dataSource = self
        let nib = UINib(nibName: "MarketingOptionTableViewCell", bundle: nil)
        marketingMixTableView.register(nib, forCellReuseIdentifier: MarketingOptionTableViewCell.preferredReuseID)
        marketingMixTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: marketingMixTableView.frame.size.width, height: 1))
    }
    
    func formatHeader() {
        headerLabel.textColor = .brandOrange
    }
    
    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MarketingOptionTableViewCell.preferredReuseID) as? MarketingOptionTableViewCell else { fatalError("Unexpected cell type found. Cannot set up marketing options table.") }
        cell.nameLabel.text = marketingOptions[indexPath.row]
        cell.descriptionLabel.text = marketingOptionSummaries[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension ExternalMarketingViewController: MarketingOptionTableViewCellDelegate {
    func marketingOptionTableViewCellShouldToggleSelectionState(_ cell: MarketingOptionTableViewCell) -> Bool {
        deselectCells()
        return true
    }
    
    func deselectCells() {
        for index in 0..<marketingOptions.count {
            if let tableViewCell = marketingMixTableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? MarketingOptionTableViewCell{
                if tableViewCell != MarketingOptionTableViewCell() {
                    tableViewCell.showActive = false
                }
            }
        }
    }
    
    func marketingOptionTableViewCell(_ cell: MarketingOptionTableViewCell, receivedRequestForInformationPage pageIndex: Int) {
        // Not using information button
    }
}
