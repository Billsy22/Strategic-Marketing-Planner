//
//  ProductsInfo.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 4/3/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

enum ProductsInfo {
    
    static let foundationProduct = [customLogo, responsiveWebsite, videoAndPhoto]
    static let internalMarketingProduct = [referralSystem, ancillaryServices, caseAcceptance, reactivationSystem, smileSavingsSystem]
    
    static let customLogo = ProductInfo(name: "Custom Logo",  price: 175)
    static let responsiveWebsite = ProductInfo(name: "Responsive Website", price: 500)
    static let videoAndPhoto = ProductInfo(name: "Video & Photo", price: 750)
    static let referralSystem = ProductInfo(name: "Referral System", price: 150)
    static let ancillaryServices = ProductInfo(name: "Ancillary Services", price: 175)
    static let caseAcceptance = ProductInfo(name: "Case Acceptance", price: 750)
    static let reactivationSystem = ProductInfo(name: "Reactivation System", price: 175)
    static let smileSavingsSystem = ProductInfo(name: "Smile Savings System", price: 350)
    
    struct ProductInfo {
        let name: String
        let price: Decimal
    }
    
}
/*
 ***FOUNDATION***
 "Custom Logo" 175
 "Responsive Website" 500
 "Video & Photo" 750
 
 ***INTERNAL MARKETING***
 "Referral System" 150
 "Ancillary Services" 175
 "Case Acceptance" 750
 "Reactivation System" 175
 "Smile Savings System" 350
 
 ***EXTERNAL MARKETING***
 "SEO"
 "Ad Design"
 "Adwords"
 "Call Training"
 "Marketing Strategy"
 "Tri-fold Brochures"
 "Brand Definition"
 "Postcard"
 "Internet Review"
 "Email Campaign"
 "Open House"
 "Mini-Zine Mailer"
 "Door Hangers"
 "8-Page Brochures"
 "Movie Theater Ad"
 "Radio Ad"
 "Facebook Jumpstart"
 "Facebook Outreach"
 "Result Tracking"
 */
