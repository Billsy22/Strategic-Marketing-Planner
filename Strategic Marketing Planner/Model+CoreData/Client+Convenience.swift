//
//  Client+Convenience.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import CoreData

extension Client {
    
    convenience init(firstName: String, lastName: String, practiceName: String, phone: String, email: String, address: String, city: String?, state: String?, zip: String, initialContact: Date, notes: String? = nil, image: UIImage? = nil, practiceType: PracticeType = .general, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        
        self.firstName = firstName
        self.lastName = lastName
        self.practiceName = practiceName
        self.phoneNumber = phone
        self.email = email
        self.streetAddress = address
        self.city = city
        self.state = state
        self.zip = zip
        self.contactDate = initialContact as NSDate
        self.notes = notes
        self.practiceType = practiceType.rawValue
        if let image = image {
            let imageData = UIImageJPEGRepresentation(image, 1)
            self.imageData = imageData as NSData?
        }
        self.marketingPlan = MarketingPlan(targetContext: context)
    }
    
    func matches(searchString: String) -> Bool {
        return firstName?.contains(searchString) ?? false || lastName?.contains(searchString) ?? false || practiceName?.contains(searchString) ?? false
    }
    
    enum PracticeType: String {
        case startup
        case general
        case specialty
    }
    
}
