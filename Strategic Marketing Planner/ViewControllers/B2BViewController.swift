//
//  B2BViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 4/9/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class B2BViewController: UIViewController, PriceLabelable, CustomNavigationController {
    func removeExternalMarketingScreen(afterViewController: UIViewController) {
        print("storyboard removed")
    }
    
    func insertNewDestination(afterViewController viewController: UIViewController, viewControllerName: String, storyboardName: String, andStoryboardId id: String) {
        print("storyboard added")
    }
    
    var customNavigationController: CustomNavigationController?
    var externalMarketingViewControllerAdded: Bool = false // limits the nav pane to only allow it to insert the viewcontroller once
    var clientController = ClientController.shared
    var client: Client? {
        return clientController.currentClient
    }
    //var client = ClientController.shared.addClient(withFirstName: "test", lastName: "test", practiceName: "test", practiceType: .specialty, phone: "8016919283", email: "test@test.com", streetAddress: "a", city: nil, state: nil, zip: "84058", initialContactDate: Date(), notes: nil)


    @IBOutlet weak var chooseBudgetLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var b2bTableView: UITableView!
    @IBOutlet weak var referralMarketingTableview: UITableView!
    let nameMap = ["Referring Doctors":MarketingPlan.BusinessToBusinessMarketing.doctors.rawValue, "Patients":MarketingPlan.BusinessToBusinessMarketing.patients.rawValue, "Both":MarketingPlan.BusinessToBusinessMarketing.both.rawValue]
    var b2bOptions: [String] {
        return nameMap.keys.map({$0})
    }
    let referralMarketingDoctorOptions = ["Option 1", "Option 2", "Option 3"]
    let referralMarketingDoctorOptionPrices: [Decimal] = [750, 1000, 1500]
    let referralMarketingBothOptions = ["Option 1", "Option 2"]
    let referralMarketingBothOptionPrices: [Decimal] = [750, 2000]
    var activeArray:[String] = []
    var activePriceArray:[Decimal] = []
    var activeName = ""
    var activePrice: Decimal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatHeader()
        formatChooseBudgetLabel()
        tableViewCustomization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTotalPriceLabel()
        restoreState()
    }
    
    func formatHeader() {
        headerLabel.textColor = .brandOrange
    }
    
    func formatChooseBudgetLabel() {
        chooseBudgetLabel.text = "Please select an option above."
    }
    
    private func restoreState() {
        guard let b2b = clientController.currentClient?.marketingPlan?.getOptionsForCategory(MarketingPlan.OptionCategory.businessToBusiness).first, let name = b2b.name, let focus = MarketingPlan.BusinessToBusinessMarketing(rawValue: name) else { return }
        switch focus {
        case .doctors:
            chooseBudgetLabel.text = "Choose a professional referral marketing budget"
            activeArray = referralMarketingDoctorOptions
            activePriceArray = referralMarketingDoctorOptionPrices
            activeName = "Referring Doctors"
            referralMarketingTableview.reloadData()
        case .patients:
            chooseBudgetLabel.text = "Please move on to External Marketing"
            activeArray = []
            activePriceArray = []
            activeName = "Patients"
            referralMarketingTableview.reloadData()
        case .both:
            chooseBudgetLabel.text = "Choose a professional referral marketing budget"
            activeArray = referralMarketingBothOptions
            activePriceArray = referralMarketingBothOptionPrices
            activeName = "Both"
            referralMarketingTableview.reloadData()
        }
        guard let option = clientController.currentClient?.marketingPlan?.getOptionsForCategory(MarketingPlan.OptionCategory.businessToBusiness).first, let price = option.price else { return }
        switch price {
        case 750:
            activePrice = 750
        case 1000:
            activePrice = 1000
        case 1500:
            activePrice = 1500
        case 2000:
            activePrice = 2000
        default:
            return
        }
    }
}

extension B2BViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == b2bTableView {
            return b2bOptions.count
        } else {
            return activeArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MarketingOptionTableViewCell.preferredReuseID) as? MarketingOptionTableViewCell else { fatalError("Unexpected cell type found. Cannot set up B2B Marketing table.") }
        if tableView == b2bTableView {
            cell.nameLabel.text = b2bOptions[indexPath.row]
            cell.descriptionLabel.text = nil
            cell.delegate = self
            if b2bOptions[indexPath.row] == activeName {
                cell.showActive = true
            }
            return cell
        } else if tableView == referralMarketingTableview {
            cell.nameLabel.text = activeArray[indexPath.row]
            cell.descriptionLabel.text = "\(NumberHelper.currencyString(for: activePriceArray[indexPath.row]) ?? "$0")"
            cell.delegate = self
            if activePriceArray[indexPath.row] == activePrice {
                cell.showActive = true
            }
            return cell
        } else {
            return cell
        }
    }
    
    func tableViewCustomization() {
        b2bTableView.dataSource = self
        let nib = UINib(nibName: "MarketingOptionTableViewCell", bundle: nil)
        b2bTableView.register(nib, forCellReuseIdentifier: MarketingOptionTableViewCell.preferredReuseID)
        b2bTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: b2bTableView.frame.size.width, height: 1))
        referralMarketingTableview.dataSource = self
        let nib2 = UINib(nibName: "MarketingOptionTableViewCell", bundle: nil)
        referralMarketingTableview.register(nib2, forCellReuseIdentifier: MarketingOptionTableViewCell.preferredReuseID)
        referralMarketingTableview.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: referralMarketingTableview.frame.size.width, height: 1))
    }
}

extension B2BViewController: MarketingOptionTableViewCellDelegate {
    func marketingOptionTableViewCellShouldToggleSelectionState(_ cell: MarketingOptionTableViewCell) -> Bool {
        guard let client = client else { return false }
        if b2bTableView.indexPath(for: cell) != nil {
            deselectCellsB2B()
            if let name = cell.nameLabel.text, let b2b = nameMap[name], let b2bFocus = MarketingPlan.BusinessToBusinessMarketing(rawValue: b2b) {
                clientController.updateB2BMarketingFocus(forClient: client, to: b2bFocus)
                switch b2bFocus {
                case .doctors:
                    chooseBudgetLabel.text = "Choose a professional referral marketing budget"
                    deselectCellsReferral()
                    activeArray = referralMarketingDoctorOptions
                    activePriceArray = referralMarketingDoctorOptionPrices
                    if externalMarketingViewControllerAdded == true {
                        customNavigationController?.removeExternalMarketingScreen(afterViewController: self)
                        externalMarketingViewControllerAdded = false
                    }
                    referralMarketingTableview.reloadData()
                case .patients:
                    chooseBudgetLabel.text = "Please move on to External Marketing"
                    deselectCellsReferral()
                    activeArray = []
                    activePriceArray = []
                    if externalMarketingViewControllerAdded == false {
                        customNavigationController?.insertNewDestination(afterViewController: self , viewControllerName: "ExternalMarketingViewController", storyboardName: "ExternalMarketing", andStoryboardId: "externalMarketing")
                        externalMarketingViewControllerAdded = true
                    }
                    referralMarketingTableview.reloadData()
                case .both:
                    chooseBudgetLabel.text = "Choose a professional referral marketing budget"
                    deselectCellsReferral()
                    activeArray = referralMarketingBothOptions
                    activePriceArray = referralMarketingBothOptionPrices
                    if externalMarketingViewControllerAdded == false {
                    customNavigationController?.insertNewDestination(afterViewController: self , viewControllerName: "ExternalMarketingViewController", storyboardName: "ExternalMarketing", andStoryboardId: "externalMarketing")
                        externalMarketingViewControllerAdded = true
                    }
                    referralMarketingTableview.reloadData()
                }
            }
        } else {
            deselectCellsReferral()
            guard  let indexOfPrice = referralMarketingTableview.indexPath(for: cell) else { return false }
            let price = activePriceArray[indexOfPrice.row]
            clientController.updateB2BMarketingBudget(forClient: client, to: price)
            updateTotalPriceLabel()
        }
        return true
    }
    
    func deselectCellsB2B() {
        for index in 0..<b2bOptions.count {
            if let tableViewCell = b2bTableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? MarketingOptionTableViewCell {
                if tableViewCell != MarketingOptionTableViewCell() {
                    tableViewCell.showActive = false
                }
            }
        }
    }
    
    func deselectCellsReferral() {
        for index in 0..<b2bOptions.count {
            if let tableViewCell = referralMarketingTableview.cellForRow(at: IndexPath.init(row: index, section: 0)) as? MarketingOptionTableViewCell {
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
