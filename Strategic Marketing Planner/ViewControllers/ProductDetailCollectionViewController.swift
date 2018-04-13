//
//  ProductDetailCollectionViewController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/5/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ProductDetailCollectionViewController: UICollectionViewController {
    
    var product: Product?
    private var contentInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    private let reuseIdentifier = "ProductPhotoCell"
    var targetPhotoHeight: CGFloat = 300
    var photoHeight: CGFloat {
        guard var availableRowWidth = collectionView?.frame.width, let product = product else { return 0 }
        availableRowWidth = availableRowWidth - contentInsets.left - contentInsets.right
        var rowWidth: CGFloat = 0
        var multiplier: CGFloat = 1
        for photo in product.images {
            let aspectRatio = photo.size.width/photo.size.height
            let photoWidth = targetPhotoHeight * aspectRatio
            rowWidth += photoWidth
            if rowWidth > availableRowWidth {
                break
            }
        }
        multiplier = (availableRowWidth)/rowWidth
        return targetPhotoHeight * multiplier
    }
    var sectionHeader: ProductDetailHeaderCollectionReusableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = contentInsets
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return product?.images.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("Unexpected cell type")
        }
        cell.imageView.image = product?.images[indexPath.row]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProductDetailHeaderCollectionReusableView.reuseID, for: indexPath) as? ProductDetailHeaderCollectionReusableView else {
                fatalError("Unexpected header view type.")
            }
            headerView.titleLabel.text = product?.title
            headerView.descriptionLabel.text = product?.intro
            headerView.includedItemsLabel.text = product?.included
            if sectionHeader == nil {
                sectionHeader = headerView
                collectionView.reloadData()
            }
            return headerView
        default:
            fatalError("Unexpected supplementary view kind.")
        }
    }
}

extension ProductDetailCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = product?.images[indexPath.row] else {
            return CGSize.zero
        }
        let aspectRatio = photo.size.width/photo.size.height
        return CGSize(width: aspectRatio * photoHeight, height: photoHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: sectionHeader?.preferredHeight ?? 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
