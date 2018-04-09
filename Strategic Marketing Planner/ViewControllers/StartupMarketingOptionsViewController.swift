//
//  StartupMarketingOptionsViewController.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 4/9/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class StartupMarketingOptionsViewController: UIViewController, PriceLabelable {
    
    // MARK: -  Properties
    @IBOutlet weak var marketingOptionsTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var costPerMonthLabel: UILabel!
    @IBOutlet weak var whatsIncludedTextView: UITextView!
    let clientController = ClientController.shared
    var client: Client? {
        //return clientController.currentClient
        return Client(firstName: "Taylor", lastName: "Bills", practiceName: "asdf", phone: "8588484848", email: "ljkadfsljkadsflkj", address: "kjlasjkfdsfdsjkfdsajkladsfjksdfalkj", city: nil, state: nil, zip: "90889", initialContact: Date(), notes: nil, image: nil, practiceType: .startup, context: CoreDataStack.context)
    }
    let startUpOptions: DictionaryLiteral<String, Int> = ["Option 1": 1250, "Option 2": 2250, "Option 3": 3250, "Option 4": 4500, "Option 5": 5500]
    var optionNames: [String] {
        return startUpOptions.map({$0.key})
    }

    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        formatHeader()
        updateTotalPriceLabel()
    }
    
    // MARK: -  UpdateViews
    func setUpTableView() {
        marketingOptionsTableView.dataSource = self
        marketingOptionsTableView.delegate = self
        let nib = UINib(nibName: "MarketingOptionTableViewCell", bundle: nil)
        marketingOptionsTableView.register(nib, forCellReuseIdentifier: MarketingOptionTableViewCell.preferredReuseID)
        marketingOptionsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: marketingOptionsTableView.frame.size.width, height: 1))
    }
    
    func formatHeader() {
        headerLabel.textColor = .brandOrange
    }
}

// MARK: -  Extension for TableViewDataSource and Delegate
extension StartupMarketingOptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: -  Table View Data Source Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MarketingOptionTableViewCell.preferredReuseID) as? MarketingOptionTableViewCell else { fatalError("Unexpected cell type found. Cannot set up marketing options table") }
        cell.delegate = self
        cell.nameLabel.text = optionNames[indexPath.row]
        cell.descriptionLabel.text = nil
        return cell
    }
}

// MARK: -  Extension for custom cell
extension StartupMarketingOptionsViewController: MarketingOptionTableViewCellDelegate {
    func marketingOptionTableViewCellShouldToggleSelectionState(_ cell: MarketingOptionTableViewCell) -> Bool {
//        guard let client = client else { return false }
        deselectCells()
        if let name = cell.nameLabel.text, let optionNames = startUpOptions.first(where: {$0.key == name}) {
            switch optionNames.key {
            case "Option 1":
                costPerMonthLabel.text = "$\(optionNames.value) per month"
                updateTotalPriceLabel()
            case "Option 2":
                costPerMonthLabel.text = "$\(optionNames.value) per month"
                updateTotalPriceLabel()
            case "Option 3":
                costPerMonthLabel.text = "$\(optionNames.value) per month"
                updateTotalPriceLabel()
            case "Option 4":
                costPerMonthLabel.text = "$\(optionNames.value) per month"
                updateTotalPriceLabel()
            case "Option 5":
                costPerMonthLabel.text = "$\(optionNames.value) per month"
                updateTotalPriceLabel()
            default:
                return false
            }
        }
        return true
    }
    
    func marketingOptionTableViewCell(_ cell: MarketingOptionTableViewCell, receivedRequestForInformationPage pageIndex: Int) {
        // No info button
    }
    
    func deselectCells() {
        for index in 0..<optionNames.count {
            if let tableViewCell = marketingOptionsTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MarketingOptionTableViewCell {
                tableViewCell.showActive = false
            }
        }
    }
}
