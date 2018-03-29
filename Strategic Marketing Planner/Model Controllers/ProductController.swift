//
//  ProductController.swift
//  Strategic Marketing Planner
//
//  Created by cruizthomason on 3/28/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ProductController {
    
    static let shared = ProductController()
    var products: [Product] = []
    
    // Any time you call this class it will fetch the products 
    init() {
        fetchProducts()
    }
    

    // MARK: - Fetch
 
    func fetchProducts() {
        
        guard let localURL = Bundle.main.url(forResource: "productPages", withExtension: "json") else {
            fatalError("badLocal url")
        }
        
        do {
            let data = try Data(contentsOf: localURL)
            productsFromJSON(data)
            
        } catch let error {
            print("Error fetching proctucts \(#function) \(error) \(error.localizedDescription)")
        }
    }
    
   @discardableResult func productsFromJSON(_ data: Data) -> [Product]? {
        do {
            
            let productsDictionary = try JSONDecoder().decode(Dictionary<String, Dictionary<String, Product>>.self, from: data)
            for key in productsDictionary.keys {
                guard let innerDictionary = productsDictionary[key] else { continue }
                for product in innerDictionary.values {
                    products.append(product)
                }
            }
            return products
        } catch let error {
            NSLog("Error decoding products from stored JSON: \(error.localizedDescription)")
            return nil
        }
    }

}
