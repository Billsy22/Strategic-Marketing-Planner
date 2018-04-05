//
//  FoundationOptionsViewController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/2/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class MarketingOptionsViewController: UIViewController {
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var marketingOptionsTableview: UITableView!
    
    var category: MarketingPlan.OptionCategory? = nil {
        didSet {
            marketingOptionsTableview?.reloadData()
        }
    }
    lazy var marketingOptions = ClientController.shared.currentClient?.marketingPlan?.getOptionsForCategory(category)
    let clientController = ClientController.shared
    let productController = ProductController.shared
    
    private var requestedProductPage: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        marketingOptionsTableview.register(UINib.init(nibName: "MarketingOptionTableViewCell", bundle: nil), forCellReuseIdentifier: MarketingOptionTableViewCell.preferredReuseID)
        marketingOptionsTableview.dataSource = self
        marketingOptionsTableview.delegate = self
        marketingOptionsTableview.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: marketingOptionsTableview.frame.size.width, height: 1))
        headerLabel.textColor = .brandOrange
        guard let category = category else { return }
        switch category {
        case .internal:
            headerLabel.text = "Internal Marketing"
            summaryLabel.text = "You should think of your external marketing as a feeder for your internal marketing. If your internal marketing systems aren't functioning efficiently, you're wasting opportunity and not maximizing your growth and profitability.\n\nOur internal systems include employee marketing training, internal marketing tools, accountability, and ongoing measurements. They focus on building habits taht become part of your daily tasks.\n\nSelect the internal systems that are right for your needs:"
        case .foundation:
            headerLabel.text = "Foundation Options"
            summaryLabel.text = "Foundation items enhance all your marketing efforts and ensure increased effectiveness."
        default:
            headerLabel.text = "Error"
        }
        totalPriceLabel.text = "$\(ClientController.shared.currentClient?.marketingPlan?.cost)/$\(ClientController.shared.currentClient?.monthlyBudget)"
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentProductDetailModal" {
            guard let destination = segue.destination as? ProductDetailViewController, let requestedPage = requestedProductPage else { return }
            let product = productController.products[requestedPage]
            destination.product = product
            requestedProductPage = nil
        }
    }
 

}

extension MarketingOptionsViewController: UITableViewDelegate {
    
}

extension MarketingOptionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let marketingOptions = marketingOptions else { return 0}
        return marketingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MarketingOptionTableViewCell.preferredReuseID) as? MarketingOptionTableViewCell else {
            fatalError("Unexpected cell type found. Cannot set up marketing options table.")
        }
        guard let marketingOptions = marketingOptions else {
            NSLog("Cannot complete cell setup because no marketing option was found for the IndexPath")
            return cell
        }
        let marketingOption = marketingOptions[indexPath.row]
        cell.marketingOption = marketingOption
        cell.delegate = self
        return cell
    }
}

extension MarketingOptionsViewController: MarketingOptionTableViewCellDelegate {
    func marketingOptionTableViewCellShouldToggleSelectionState(_ cell: MarketingOptionTableViewCell) -> Bool {
        guard let marketingOption = cell.marketingOption, let currentClient = clientController.currentClient else { return  false }
        clientController.toggleActivationForMarketingOption(marketingOption, forClient: currentClient)
        return true
    }
    
    func marketingOptionTableViewCell(_ cell: MarketingOptionTableViewCell, receivedRequestForInformationPage pageIndex: Int) {
        requestedProductPage = pageIndex
        performSegue(withIdentifier: "presentProductDetailModal", sender: self)
    }
    
}
