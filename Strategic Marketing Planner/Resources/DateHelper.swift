//
//  DateHelper.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 3/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

class DateHelper {
    
    static func dateFrom(string: String) -> Date {
        let dateFormatter = DateFormatter()
        guard let date = dateFormatter.date(from: string) else { return Date() }
        return date
    }
    
    static func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from:date)
    }
}
