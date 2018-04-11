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
    @IBOutlet weak var trainingLabel: UILabel!
    @IBOutlet weak var productDetailCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    
    
    let cellHeight: CGFloat = 255
    var numberOfRows: Int {
        let availableWidth = productDetailCollectionView.frame.size.width
        var imagesWidth: CGFloat = 0
        for image in images {
            let sizeFraction = image.size.height/cellHeight
            let imageWidth = image.size.width/sizeFraction
            imagesWidth += imageWidth
        }
        return Int(ceil(imagesWidth/availableWidth))
    }
    
    lazy var images = product?.images ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        productDetailCollectionView.delegate = self
        productDetailCollectionView.dataSource = self
        collectionViewHeight.constant = CGFloat(numberOfRows) * cellHeight + 10
      
    }
    //  MARK: - Actions
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true) {
            print("View Dismissed")
        }
    }
    var product: Product?

   
    func updateViews() {
        title = product?.title
        
        // Unwrap product
        guard let product = product else { return }
   
        // outlets to product.property
        titleLabel.text = product.title
        discriptionLabel.text = product.intro
        whatsIncludedLabel.text = "What's Included:"
        includedItemsLabel.text = product.included
        trainingLabel.text = product.training
        
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
        let image = images[indexPath.row]
        let sizeFraction = image.size.height/cellHeight
        return CGSize(width: image.size.width / sizeFraction, height: cellHeight)
    
    }
    
}
