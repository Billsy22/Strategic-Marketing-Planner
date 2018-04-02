//
//  ProductListTableViewController.swift
//  Strategic Marketing Planner
//
//  Created by cruizthomason on 3/29/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ProductListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductController.shared.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        // you want one product for every cell - get the indexPath.row out of yoour source of truth

        let product = ProductController.shared.products[indexPath.row]
        cell.textLabel?.text = product.title
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProductDetail" {
            guard let destinationVC = segue.destination as? ProductDetailViewController,
                let selectedProduct = tableView.indexPathForSelectedRow?.row else { return }
                let product = ProductController.shared.products[selectedProduct]
            destinationVC.product = product
            
        }
    }
}
