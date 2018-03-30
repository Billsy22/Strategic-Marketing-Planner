//
//  ProductsCollectionViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 3/28/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

private let reuseIdentifier = "productCell"
private let segueIdentifier = "toProductDetailPDF"

class ProductsCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    let productsArray: [String] = ["SEO", "Ad Design", "Adwords", "Referral System", "Call Training", "Custom Logo", "Responsive Website", "Marketing Strategy", "Video & Photo", "Tri-fold Brochures", "Brand Definition", "Ancillary Services", "Postcard", "Internet Review", "Email Campaign", "Smile Savings System", "Reactivation System", "Case Acceptance", "Open House", "Mini-Zine Mailer", "Door Hangers", "8-Page Brochures", "Movie Theater Ad", "Radio Ad", "Facebook Jumpstart", "Facebook Outreach", "Result Tracking"]
    //let imagesArray: [UIImage] = [#imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable"), #imageLiteral(resourceName: "imageNotAvailable")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatNavigationBar()
    }
    
    func formatNavigationBar() {
        navigationController?.navigationBar.barTintColor = .brandBlue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier,
            let cell = sender as? ProductCollectionViewCell,
            let indexPath = collectionView?.indexPath(for: cell) {
            let detailVC = segue.destination as? ProductDetailPDFViewController
            let product = productsArray[indexPath.row]
            detailVC?.product = product
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        cell.productNameLabel.text = productsArray[indexPath.row]
        cell.productImageView.image = #imageLiteral(resourceName: "imageNotAvailable") //imagesArray[indexPath.row]
        // TODO: - Need to implement photos for product cells.
        return cell
    }
}
