//
//  Product.swift
//  Strategic Marketing Planner
//
//  Created by cruizthomason on 3/28/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class Product: Codable {
    
    var title: String
    var intro: String
    var included: String
    var training: String?
    private var image1Name: String?
    private var image2Name: String?
    private var image3Name: String?
    private var image4Name: String?
    private var image5Name: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case intro
        case included
        case training
        
        case image1Name = "image1"
        case image2Name = "image2"
        case image3Name = "image3"
        case image4Name = "image4"
        case image5Name = "image5"
        
    }
    
    var images: [UIImage] {
        var images: [UIImage] = []
        if let image1Name = image1Name, let firstImage = UIImage(named: image1Name) {
            images.append(firstImage)
        }
        if let image2Name = image2Name, let secondImage = UIImage(named: image2Name) {
            images.append(secondImage)
        }
        if let image3Name = image3Name, let thirdImage = UIImage(named: image3Name) {
            images.append(thirdImage)
        }
        if let image4Name = image4Name, let fourthImage = UIImage(named: image4Name) {
            images.append(fourthImage)
        }
        if let image5Name = image5Name, let fifthImage = UIImage(named: image5Name) {
            images.append(fifthImage)
        }
        
        return images
    }
    
    init(title: String, intro: String, included: String, training: String?, image1Name: String?, image2Name: String?, image3Name: String?, image4Name: String?, image5Name: String?) {
        
        self.title = title
        self.intro = intro
        self.included = included
        self.training = training
        self.image1Name = image1Name
        self.image2Name = image2Name
        self.image3Name = image3Name
        self.image4Name = image4Name
        self.image5Name = image5Name
    }
    
    
}

