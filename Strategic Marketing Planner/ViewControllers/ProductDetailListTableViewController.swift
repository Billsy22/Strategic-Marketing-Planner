//
//  ProductDetailListTableViewController.swift
//  Strategic Marketing Planner
//
//  Created by cruizthomason on 3/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var whatsIncludedLabel: UILabel!
    @IBOutlet weak var includedItemsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
      
    }
    var product: Product?

    
    func updateViews() {
        title = product?.title
    }

}
