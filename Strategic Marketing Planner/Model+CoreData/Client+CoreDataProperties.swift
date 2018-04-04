//
//  Client+CoreDataProperties.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/3/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//
//

import Foundation
import CoreData


extension Client {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var city: String?
    @NSManaged public var contactDate: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var lastName: String?
    @NSManaged public var notes: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var practiceName: String?
    @NSManaged public var state: String?
    @NSManaged public var streetAddress: String?
    @NSManaged public var zip: String?
    @NSManaged public var practiceType: String?
    @NSManaged public var marketingPlan: MarketingPlan?
    
    

}
