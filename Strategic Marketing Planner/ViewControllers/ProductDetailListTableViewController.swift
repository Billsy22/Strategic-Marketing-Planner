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
    @IBOutlet weak var productDetailCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        productDetailCollectionView.delegate = self
        productDetailCollectionView.dataSource = self
      
    }
    var product: Product?

   
    func updateViews() {
        title = product?.title
        
        // Unwrap product
        guard let product = product else { return }
   
        // outlets to product.property
        titleLabel.text = product.title
        discriptionLabel.text = product.intro
        whatsIncludedLabel.text = product.included
        includedItemsLabel.text = product.training
        
    }
}

extension ProductDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productImageCount = self.product?.images.count else { print("na"); return 0}
        print(productImageCount)
        
        return productImageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? ProductDetailCollectionViewCell else { return UICollectionViewCell() }
        
        guard let prodcut = product else { return UICollectionViewCell() }
        let productImages = prodcut.images[indexPath.row]
        
        //cell.productDetailImageView.image = ProductController.shared.productImage(indexPath: indexPath)
        cell.productDetailImageView.image = productImages
        
        return cell
    }
    
    // MARK: - Flow
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 300, height: 200)
    }
    
}
