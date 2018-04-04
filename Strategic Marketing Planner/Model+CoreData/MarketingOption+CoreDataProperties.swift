//
//  MarketingOption+CoreDataProperties.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/3/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//
//

import Foundation
import CoreData


extension MarketingOption {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MarketingOption> {
        return NSFetchRequest<MarketingOption>(entityName: "MarketingOption")
    }

    @NSManaged public var category: String?
    @NSManaged public var descriptionPageIndex: NSNumber?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var summary: String?
    @NSManaged public var plan: MarketingPlan?

}
