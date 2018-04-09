//
//  MarketingOption+Convenience.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/9/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

extension MarketingOption {
    
    convenience init(name: String, price: Decimal, category: MarketingPlan.OptionCategory, description: String? = nil, isActive: Bool = false, extendedDescriptionIndex: Int? = nil, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.category = category.rawValue
        self.summary = description
        self.descriptionPageIndex = extendedDescriptionIndex as NSNumber?
        self.isActive = isActive
        self.price = price as NSDecimalNumber
    }
    
}

extension MarketingOption: CloudKitSynchable {
    
    struct Relationships {
        static let marketingPlan = "MarketingPlan"
    }
    
    func addCKReferencesToCKRecord(_ record: CKRecord) {
        guard let marketingPlan = plan, let marketingPlanRecord = marketingPlan.asCKRecord else { return }
        let reference = CKReference(record: marketingPlanRecord, action: .deleteSelf)
        record[Relationships.marketingPlan] = reference
    }
    
    static func initializeRelationshipsFromReferences(_ record: CKRecord, model: MarketingOption) -> Bool {
        guard let planReference = record[Relationships.marketingPlan] as? CKReference else { return false }
        let marketingPlanName = planReference.recordID.recordName
        guard let plan = ClientController.shared.clients.first(where: {$0.marketingPlan?.recordName == marketingPlanName})?.marketingPlan else { return false }
        plan.addToOptions(model)
        return true
    }
    
}
