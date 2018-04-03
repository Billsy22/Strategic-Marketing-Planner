//
//  FoundationOptionsViewController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/2/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class MarketingOptionsViewController: UIViewController {
    
    @IBOutlet weak var marketingOptionsTableview: UITableView!
    
    var marketingOptions: [MarketingOption]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        marketingOptionsTableview.register(UINib.init(nibName: "MarketingOptionTableViewCell", bundle: nil), forCellReuseIdentifier: MarketingOptionTableViewCell.preferredReuseID)
        marketingOptionsTableview.dataSource = self
        marketingOptionsTableview.delegate = self
        marketingOptionsTableview.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: marketingOptionsTableview.frame.size.width, height: 1))
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
        return cell
    }
    
    
}
