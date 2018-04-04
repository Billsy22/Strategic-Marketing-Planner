//
//  MarketingPlan+CoreDataProperties.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/3/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//
//

import Foundation
import CoreData


extension MarketingPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MarketingPlan> {
        return NSFetchRequest<MarketingPlan>(entityName: "MarketingPlan")
    }

    @NSManaged public var cost: NSDecimalNumber?
    @NSManaged public var targetBudget: NSDecimalNumber?
    @NSManaged public var client: Client?
    @NSManaged public var options: NSOrderedSet?

}

// MARK: Generated accessors for options
extension MarketingPlan {

//    @objc(insertObject:inOptionsAtIndex:)
//    @NSManaged public func insertIntoOptions(_ value: MarketingOption, at idx: Int)
//
//    @objc(removeObjectFromOptionsAtIndex:)
//    @NSManaged public func removeFromOptions(at idx: Int)
//
//    @objc(insertOptions:atIndexes:)
//    @NSManaged public func insertIntoOptions(_ values: [MarketingOption], at indexes: NSIndexSet)
//
//    @objc(removeOptionsAtIndexes:)
//    @NSManaged public func removeFromOptions(at indexes: NSIndexSet)
//
//    @objc(replaceObjectInOptionsAtIndex:withObject:)
//    @NSManaged public func replaceOptions(at idx: Int, with value: MarketingOption)
//
//    @objc(replaceOptionsAtIndexes:withOptions:)
//    @NSManaged public func replaceOptions(at indexes: NSIndexSet, with values: [MarketingOption])
//
//    @objc(addOptionsObject:)
//    @NSManaged public func addToOptions(_ value: MarketingOption)
//
//    @objc(removeOptionsObject:)
//    @NSManaged public func removeFromOptions(_ value: MarketingOption)
//
//    @objc(addOptions:)
//    @NSManaged public func addToOptions(_ values: NSOrderedSet)
//
//    @objc(removeOptions:)
//    @NSManaged public func removeFromOptions(_ values: NSOrderedSet)

}
