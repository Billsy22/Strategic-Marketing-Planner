//
//  Client+Convenience.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CoreData

extension Client {
    
    convenience init(firstName: String, lastName: String, practiceName: String, phone: String, email: String, address: String, city: String?, state: String?, zip: String, initialContact: Date, notes: String?, context: NSManagedObjectContext = CoreDataStack.context){
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
        self.contactDate = initialContact
        self.notes = notes
    }
    
}
