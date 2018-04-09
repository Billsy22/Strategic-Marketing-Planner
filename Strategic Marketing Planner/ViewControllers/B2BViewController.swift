//
//  B2BViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 4/9/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class B2BViewController: UIViewController {
    
//    var client: Client? {
//        return clientController.currentClient
//    }
//
//    var clientController: ClientController

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var b2bTableView: UITableView!
    @IBOutlet weak var referralMarketingTableview: UITableView!
    let b2bOptions = ["Referring Doctors", "Patients"]
    let referralMarketingOptions = ["Option 1", "Option 2", "Option 3"]
    let referralMarketingOptionSummaries = ["$750", "$1,000", "$1,500"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatHeader()
        tableViewCustomization()
        //updateTotalPriceLabel()
    }
    
    func formatHeader() {
        headerLabel.textColor = .brandOrange
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension B2BViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == b2bTableView {
            return b2bOptions.count
        } else if tableView == referralMarketingTableview {
            return referralMarketingOptions.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MarketingOptionTableViewCell.preferredReuseID) as? MarketingOptionTableViewCell else { fatalError("Unexpected cell type found. Cannot set up B2B Marketing table.") }
        if tableView == b2bTableView {
            cell.nameLabel.text = b2bOptions[indexPath.row]
            cell.descriptionLabel.text = nil
            cell.delegate = self as? MarketingOptionTableViewCellDelegate
            return cell
        } else if tableView == referralMarketingTableview {
            cell.nameLabel.text = referralMarketingOptions[indexPath.row]
            cell.descriptionLabel.text = referralMarketingOptionSummaries[indexPath.row]
            cell.delegate = self as? MarketingOptionTableViewCellDelegate
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

//extension B2BViewController: MarketingOptionTableViewCellDelegate {
//    func marketingOptionTableViewCellShouldToggleSelectionState(_ cell: MarketingOptionTableViewCell) -> Bool {
//        guard let client = client else { return false }
//    }
//
//    func marketingOptionTableViewCell(_ cell: MarketingOptionTableViewCell, receivedRequestForInformationPage pageIndex: Int) {
//        <#code#>
//    }
//
//
//}
