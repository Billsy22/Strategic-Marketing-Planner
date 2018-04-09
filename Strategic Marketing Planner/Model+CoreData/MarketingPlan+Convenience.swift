//
//  MarketingPlan+Convenience.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/1/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

extension MarketingPlan {
    
    enum OptionCategory: String {
        case foundation
        case `internal`
        case external
        case suburban
        case startup
        case businessToBusiness
    }
    
    var cost: Decimal {
        var currentCost: Decimal = 0
        if let options = options {
            for option in options {
                if let marketingOption = option as? MarketingOption, marketingOption.isActive {
                    currentCost += marketingOption.price?.decimalValue ?? 0
                }
            }
        }
        return currentCost
    }
    
    convenience init(practiceType: Client.PracticeType, targetContext context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        options = NSOrderedSet()
        switch practiceType {
        case .general:
            setupGeneralPracticeMarketingOptions()
        case .specialty:
            options = setupDefaultMarketingOptions()
        case .startup:
            options = setupDefaultMarketingOptions()
        }
    }
    
    private func setupDefaultMarketingOptions() -> NSOrderedSet{
        let options = NSMutableOrderedSet()
        let customLogo = MarketingOption(name: "Custom Logo", price: 500, category: .foundation, description: nil, isActive: false)
        let logoIndex = ProductController.shared.products.index { (product) -> Bool in
            return product.title == customLogo.name
        }
        customLogo.descriptionPageIndex = logoIndex as NSNumber?
        let responsiveWebsite = MarketingOption(name: "Responsive Website", price: 1000, category: .foundation)
        let hosting = MarketingOption(name: "12 Months of Hosting", price: 50, category: .foundation)
        let videoAndPhotography = MarketingOption(name: "Video and Photography", price: 1000, category: .foundation)
        options.add(customLogo)
        options.add(responsiveWebsite)
        options.add(hosting)
        options.add(videoAndPhotography)
        return options
    }
    
    private func setupGeneralPracticeMarketingOptions()  {
        let options = NSMutableOrderedSet()
        for productInfo in ProductsInfo.foundationProduct {
            let descriptionIndex = ProductController.shared.products.index { (product) -> Bool in
                return product.title == productInfo.name
            }
            let marketingOption = MarketingOption(name: productInfo.name, price: productInfo.price, category: .foundation, description: nil, isActive: false, extendedDescriptionIndex: descriptionIndex)
            options.add(marketingOption)
            }
        for productInfo in ProductsInfo.internalMarketingProduct {
            let descriptionIndex = ProductController.shared.products.index { (product) -> Bool in
                return product.title == productInfo.name
            }
            let marketingOption = MarketingOption(name: productInfo.name, price: productInfo.price, category: .internal, description: nil, isActive: false, extendedDescriptionIndex: descriptionIndex)
            options.add(marketingOption)
        }
        let externalMarketingOption = MarketingOption(name: "no option selected", price: 0, category: .external, description: nil, isActive: true, extendedDescriptionIndex: nil)
        addToOptions(externalMarketingOption)
        addToOptions(options)
    }
    
    func getOptionsForCategory(_ category: OptionCategory?, includeOnlyActive: Bool = false) -> [MarketingOption]{
        guard let category = category else { return [] }
        var selectedOptions: [MarketingOption] = []
        guard let options = self.options else {
            NSLog("No options found for category because the marketing plan's options have not been initialized.  This most likely represents an invalid state.")
            return []
        }
        for option in options {
            guard let marketingOption = option as? MarketingOption, let optionCategory = marketingOption.category else { continue }
            if optionCategory == category.rawValue {
                if includeOnlyActive && marketingOption.isActive || includeOnlyActive == false {
                    selectedOptions.append(marketingOption)
                }
            }
        }
        return selectedOptions
    }
    
    enum ExternalMarketingFocus: String {
        case digital
        case traditional
        case digitalTraditionalMix
    }
    
    enum BusinessToBusinessMarketing: String {
        case doctors
        case patients
        case both
    }
    
}

extension MarketingPlan: CloudKitSynchable {
    
    struct Relationships {
        static let client = "Client"
        //Relationship to marketinging option not needed, as it is the job of the marketing option to have a reference to its parent.
    }
    
    func addCKReferencesToCKRecord(_ record: CKRecord) {
        guard let client = client else { return }
        let clientRecord = client.asCKRecord 
        let reference = CKReference(record: clientRecord, action: .deleteSelf)
        record[Relationships.client] = reference
    }
    
    static func initializeRelationshipsFromReferences(_ record: CKRecord, model: MarketingPlan) -> Bool {
        guard let clientReference = record[Relationships.client] as? CKReference else { return false }
        let clientRecordName = clientReference.recordID.recordName
        guard let client = ClientController.shared.clients.first(where: {$0.recordName == clientRecordName}) else { return false }
        ClientController.shared.setMarketingPlan(model, forClient: client)
        return true
    }

}
