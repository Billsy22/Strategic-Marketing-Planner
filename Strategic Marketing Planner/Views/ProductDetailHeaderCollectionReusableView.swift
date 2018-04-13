//
//  ProductDetailHeaderCollectionReusableView.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/5/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ProductDetailHeaderCollectionReusableView: UICollectionReusableView {
    
    static let reuseID = "ProductDetailHeaderCollectionReuasableView"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var includedItemsLabel: UILabel!
    @IBOutlet weak var whatsIncludedLabel: UILabel!
    
    var preferredHeight: CGFloat {
        return self.frame.size.height
        //return titleLabel.intrinsicContentSize.height + descriptionLabel.intrinsicContentSize.height + includedItemsLabel.intrinsicContentSize.height + whatsIncludedLabel.intrinsicContentSize.height + 40
//        return intrinsicContentSize.height
    }
    
    
}
