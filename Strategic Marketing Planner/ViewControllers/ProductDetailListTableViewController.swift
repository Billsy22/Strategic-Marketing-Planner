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
    
    
    
    var cellSizes: [CGSize] = []
    var imagesHeight: CGFloat = 0
    
    var numberColumns = 2
    var imageWidth: CGFloat = 0
    
    var cellHeight: CGFloat = 200
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
        collectionViewHeight.constant = cellHeight
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //collectionViewHeight.constant = CGFloat(numberOfRows) * cellHeight
        setupCollectionViewDimensions(numberOfColumns: 2)
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
        titleLabel.textColor = UIColor.brandOrange
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
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 20
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 20
    //    }
    
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
        if indexPath.row < cellSizes.count{
            return cellSizes[indexPath.row]
        } else {
            return CGSize.zero
        }
    }
    
    private func setupCollectionViewDimensions(numberOfColumns: Int) {
        
        //This is needed because otherwise the collectionView's frame and bound may be wrong, and they're needed for size calculations.
        productDetailCollectionView.layoutIfNeeded()
        var requiredHeight: CGFloat = 0
        cellSizes = []
        guard let layout = productDetailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            collectionViewHeight.constant = 0
            return
        }
        
        let numberOfColumns = images.count > numberOfColumns ? numberOfColumns : images.count
        
        let numberOfRows = images.count % numberOfColumns == 0 ? images.count / numberOfColumns : images.count / numberOfColumns + 1
        
        let horizontalEmptySpace = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing * CGFloat(numberOfColumns - 1) + 1
        let verticalEmptySpace = layout.sectionInset.top + layout.sectionInset.bottom + layout.minimumLineSpacing * CGFloat(numberOfRows - 1)
        requiredHeight += verticalEmptySpace
        let availableWidth = productDetailCollectionView.bounds.width - horizontalEmptySpace
        let cellWidth = availableWidth/CGFloat(numberOfColumns)
        var imagesProcessed = 0
        rowProcessing: for _ in 0..<numberOfRows {
            var rowHeight: CGFloat = 0
            for _ in 0..<numberOfColumns{
                guard imagesProcessed < images.count else {
                    requiredHeight += rowHeight
                    break rowProcessing
                }
                let image = images[imagesProcessed]
                let sizeFraction = image.size.width/cellWidth
                let cellHeight = image.size.height/sizeFraction
                rowHeight = max(rowHeight, cellHeight)
                cellSizes.append(CGSize(width: cellWidth, height: cellHeight))
                
                self.cellHeight = cellHeight
                imagesProcessed += 1
            }
            requiredHeight += rowHeight
        }
        
        collectionViewHeight.constant = requiredHeight
        
        //Needed because laying out the collectionview at the begining of this function caused the cell sizes to be requested, and the collectionview was given 0 for all of them since the sizes hadn't been calculated yet.
        
        productDetailCollectionView.reloadData()
    }
    
}
