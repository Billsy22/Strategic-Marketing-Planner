//
//  PriceLableable.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/5/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

protocol PriceLabelable: class {
    var totalPriceLabel: UILabel! { get }
    var client: Client? { get }
}

extension PriceLabelable where Self: UIViewController {
    func updateTotalPriceLabel(){
        guard let client = client, let marketingPlan = client.marketingPlan, let marketingPrice = NumberHelper.currencyString(for: marketingPlan.cost), let monthlyBudget = client.monthlyBudget, let budgetPrice = NumberHelper.currencyString(for: monthlyBudget as Decimal) else { return }
        let priceColor = marketingPlan.cost > monthlyBudget as Decimal ? UIColor.red : UIColor.black
        let priceAttributedString = NSMutableAttributedString(string: marketingPrice, attributes: [NSAttributedStringKey.foregroundColor:priceColor])
        priceAttributedString.append(NSAttributedString(string: "/\(budgetPrice)"))
        totalPriceLabel.attributedText = priceAttributedString
    }
}
