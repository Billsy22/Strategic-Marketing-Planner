//
//  NumberHelper.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/5/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

enum NumberHelper {
    
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "$"
        return numberFormatter
    }
    
    static func currencyString(`for` number: Decimal) -> String? {
        return numberFormatter.string(from: number as NSDecimalNumber)
    }
    
    static func currencyString(`for` number: Double) -> String? {
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    static func currencyString(`for` number: Float) -> String? {
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    static func decimalNumber(`for` string: String) -> Decimal? {
        let number = numberFormatter.number(from: string)
        return number?.decimalValue
    }
    
}
