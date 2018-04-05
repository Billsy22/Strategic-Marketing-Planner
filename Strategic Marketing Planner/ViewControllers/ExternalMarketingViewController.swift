//
//  ExternalMarketingViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 4/4/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ExternalMarketingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var client: Client? {
        return clientController.currentClient
    }
    
    let clientController = ClientController.shared
    
    let nameMap = ["Urban":MarketingPlan.ExternalMarketingFocus.digital.rawValue, "Suburban":MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue,"Rural":MarketingPlan.ExternalMarketingFocus.traditional.rawValue]
    var marketingOptions: [String] {
        return nameMap.keys.map({$0})
    }
    let marketingOptionSummaries = ["A digital marketing focus. Ideal for highly populated areas.", "A mix of digital and traditional marketing to maximize results in a suburban demographic.", "A traditional marketing focus. Ideal for rural areas."]
    
    let urbanPrices: [Float] = [0, 750, 1750, 2750, 3750, 4750]
    let suburbanPrices: [Float] = [0, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 5500, 6000, 6500]
    let ruralPrices: [Float] = [0, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 5000, 6000]
    var sliderPrices: [Float] = [0] {
        didSet {
            pricePerMonthSlider.minimumValue = sliderPrices.min() ?? 0
            pricePerMonthSlider.maximumValue = sliderPrices.max() ?? 0
            computeNewSliderValue(pricePerMonthSlider)
        }
    }
    
    var activeName: String = ""
    
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
        computeNewSliderValue(sender)
    }
    
    private func computeNewSliderValue(_ slider: UISlider){
        var closestDistance = Float.greatestFiniteMagnitude
        guard var closestValue = sliderPrices.first else { return }
        for price in sliderPrices {
            let distance = abs(price - slider.value)
            if distance < closestDistance {
                closestValue = price
                closestDistance = distance
            }
        }
        slider.value = closestValue
        pricePerMonthLabel.text = "\(NumberHelper.currencyString(for: slider.value) ?? "$0") per month"
        guard let client = client else { return }
        clientController.updateExternalMarketingBudget(Decimal.init(Double(slider.value)), forClient: client)
        if slider.value == 0 {
            clientController.deactivateExternalMarketing(forClient: client)
        }else{
            clientController.activateExternalMarketing(forClient: client)
        }
        updateTotalPriceLabel()
    }
    
    private func restoreState(){
        guard let externalMarketing = clientController.currentClient?.marketingPlan?.getOptionsForCategory(MarketingPlan.OptionCategory.external).first, let name = externalMarketing.name, let focus = MarketingPlan.ExternalMarketingFocus(rawValue: name), let price = externalMarketing.price else { return }
        
        switch focus {
        case .digital:
            sliderPrices = urbanPrices
            pricePerMonthSlider.value = Float(truncating: price)
            sliderValueSelected(pricePerMonthSlider)
            marketingToLabel.text = marketingToUrban
            activeName = "Urban"
            
        case .digitalTraditionalMix:
            sliderPrices = suburbanPrices
            pricePerMonthSlider.value = Float(truncating: price)
            sliderValueSelected(pricePerMonthSlider)
            marketingToLabel.text = marketingToSuburban
            activeName = "Suburban"
            
        case .traditional:
            sliderPrices = ruralPrices
            pricePerMonthSlider.value = Float(truncating: price)
            sliderValueSelected(pricePerMonthSlider)
            marketingToLabel.text = marketingToRural
            activeName = "Rural"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatHeader()
        tableViewCustomization()
        formatSlider()
        updateTotalPriceLabel()
        //marketingToLabel.text = marketingToSuburban
    }
    
    override func viewWillAppear(_ animated: Bool) {
        restoreState()
    }
    
    func formatSlider() {
//        pricePerMonthSlider.maximumValue = Float(suburbanPrices.count - 1)
        pricePerMonthSlider.tintColor = .brandBlue
        pricePerMonthSlider.value = 0
    }
    
    func updateTotalPriceLabel() {
        guard let client = client, let marketingPlan = client.marketingPlan, let marketingPrice = NumberHelper.currencyString(for: marketingPlan.cost), let monthlyBudget = client.monthlyBudget, let budgetPrice = NumberHelper.currencyString(for: monthlyBudget as Decimal) else { return }
        totalPriceLabel.text = "\(marketingPrice)/\(budgetPrice)"
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
        if marketingOptions[indexPath.row] == activeName {
            cell.showActive = true
        }
        return cell
    }
}

extension ExternalMarketingViewController: MarketingOptionTableViewCellDelegate {
    func marketingOptionTableViewCellShouldToggleSelectionState(_ cell: MarketingOptionTableViewCell) -> Bool {
        guard let client = client else { return false }
        deselectCells()
        if let name = cell.nameLabel.text, let externalFocus = nameMap[name], let externalMarketingFocus = MarketingPlan.ExternalMarketingFocus(rawValue: externalFocus) {
            clientController.updateExternalMarketingFocus(externalMarketingFocus, forClient: client)
            switch externalMarketingFocus {
            case .digital:
                sliderPrices = urbanPrices
                marketingToLabel.text = marketingToUrban
            case .digitalTraditionalMix:
                sliderPrices = suburbanPrices
                marketingToLabel.text = marketingToSuburban
            case .traditional:
                sliderPrices = ruralPrices
                marketingToLabel.text = marketingToRural
            }
        }
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
