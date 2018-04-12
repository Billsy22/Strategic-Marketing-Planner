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
    static let responsiveWebsite = ProductInfo(name: "Responsive Website & 12 Months Hosting", price: 500)
    static let videoAndPhoto = ProductInfo(name: "Video & Photography", price: 750)
    static let referralSystem = ProductInfo(name: "Referral System", price: 150)
    static let ancillaryServices = ProductInfo(name: "Ancillary Services", price: 175)
    static let caseAcceptance = ProductInfo(name: "Case Acceptance", price: 750)
    static let reactivationSystem = ProductInfo(name: "Reactivation System", price: 175)
    static let smileSavingsSystem = ProductInfo(name: "Smile Savings System", price: 350)
    
    struct ProductInfo {
        let name: String
        let price: Decimal
    }
    
    static let urbanKey = MarketingPlan.ExternalMarketingFocus.digital.rawValue
    static let suburbanKey = MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue
    static let ruralKey = MarketingPlan.ExternalMarketingFocus.traditional.rawValue
    static let startupKey = MarketingPlan.OptionCategory.startup.rawValue
    
    static let urbanValue = assembleUrbanDictionary()
    static let suburbanValue = assembleSuburbanDictionary()
    static let ruralValue = assembleRuralDictionary()
    
    static let startupMarketingDictionary = assembleStartupPackagesDictionary()
    
    static let externalMarketingDictionary: Dictionary<String,Dictionary<Int,[String]>> = [urbanKey : urbanValue, suburbanKey : suburbanValue, ruralKey : ruralValue]
    
    private static func assembleUrbanDictionary() -> Dictionary<Int,[String]> {
        var dictionary = Dictionary<Int,[String]>()
        dictionary.updateValue(["SEO", "Internet Review", "Facebook Outreach"], forKey: 750)
        dictionary.updateValue(["SEO", "AdWords", "Email Campaign", "Facebook Jumpstart", "Facebook Outreach"], forKey: 1750)
        dictionary.updateValue(["Results Tracking", "Marketing Strategy", "SEO", "Internet Review", "AdWords", "Email Campaign", "Facebook Jumpstart", "Facebook Outreach"], forKey: 2750)
        dictionary.updateValue(["Results Tracking", "Marketing Strategy", "SEO", "Internet Review", "AdWords", "Email Campaign", "Facebook Jumpstart", "Facebook Outreach"], forKey: 3750)
        dictionary.updateValue(["Results Tracking", "Marketing Strategy", "SEO", "Internet Review", "AdWords", "Email Campaign", "Facebook Jumpstart", "Facebook Outreach"], forKey: 4750)
        return dictionary
    }
    
    private static func assembleSuburbanDictionary() -> Dictionary<Int,[String]> {
        var dictionary = Dictionary<Int,[String]>()
        dictionary.updateValue(["Ad Design", "Tri-fold Brochures", "SEO"], forKey: 500)
        dictionary.updateValue(["Ad Design", "Tri-fold Brochures", "SEO", "Internet Review", "Facebook Jumpstart"], forKey: 1000)
        dictionary.updateValue(["Postcard", "SEO", "Internet Review"], forKey: 1500)
        dictionary.updateValue(["Result Tracking", "Marketing Strategy", "Postcard", "Tri-fold Brochures", "Ad Design", "Movie Theater Ad"], forKey: 2000)
        dictionary.updateValue(["Result Tracking", "Marketing Strategy", "Postcard", "SEO", "Internet Review", "Adwords", "Facebook Outreach"], forKey: 2500)
        dictionary.updateValue(["Result Tracking", "Marketing Strategy", "Postcard", "Tri-fold Brochures", "Ad Design", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"], forKey: 3000)
        dictionary.updateValue(["Result Tracking", "Marketing Strategy", "Postcard", "Ad Design", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"], forKey: 3500)
        dictionary.updateValue(["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Tri-fold Brochures", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"], forKey: 4000)
        dictionary.updateValue(["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "SEO", "Internet Review", "Adwords", "Facebook Outreach"], forKey: 4500)
        dictionary.updateValue(["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Tri-fold Brochures", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"], forKey: 5000)
        dictionary.updateValue(["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Movie Theater Ad", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"], forKey: 5500)
        dictionary.updateValue(["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Movie Theater Ad", "Tri-fold Brochures", "SEO", "Internet Review", "Adwords", "Email Campaign", "Facebook Jumpstart", "Facebook Outreach"], forKey: 6000)
        dictionary.updateValue(["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Movie Theater Ad", "Tri-fold Brochures", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"], forKey: 6500)
        return dictionary
    }
    
    private static func assembleRuralDictionary() -> Dictionary<Int,[String]> {
        var dictionary = Dictionary<Int,[String]>()
        dictionary.updateValue(["Ad Design", "Tri-fold Brochures"], forKey: 500)
        dictionary.updateValue( ["Door Hangers", "Ad Design", "Movie Theater Ad", "Tri-fold Brochures"], forKey: 1000)
        dictionary.updateValue(["Postcard", "Ad Design", "Tri-fold Brochures"], forKey: 1500)
        dictionary.updateValue(["Results Tracking", "Marketing Strategy", "Postcard", "Ad Design", "Tri-fold Brochures"], forKey: 2000)
        dictionary.updateValue(["Results Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "8-Page Brochures"], forKey: 2500)
        dictionary.updateValue( ["Results Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Tri-fold Brochures"], forKey: 3000)
        dictionary.updateValue(["Results Tracking", "Marketing Strategy", "Postcard", "Ad Design", "Tri-fold Brochures"], forKey: 3500)
        dictionary.updateValue(["Results Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Radio Ad", "Movie Theater Ad", "8-Page Brochures"], forKey: 4000)
        dictionary.updateValue(["Results Tracking", "Marketing Strategy", "Postcard", "Mini-Zine Mailer", "Ad Design", "Radio Ad", "Movie Theater Ad", "8-Page Brochures"], forKey: 5000)
        dictionary.updateValue(["Results Tracking", "Marketing Strategy", "Postcard", "Mini-Zine Mailer", "Ad Design", "Radio Ad", "Movie Theater Ad", "8-Page Brochures"], forKey: 6000)
        return dictionary
    }
    
    private static func assembleStartupPackagesDictionary() -> Dictionary<Int,[String]> {
        var dictionary = Dictionary<Int,[String]>()
        dictionary.updateValue(["Brand Definition", "Custom Logo", "Responsive Website & 12 Months Hosting", "Comprehensive Results Tracking", "Referral System", "SEO"], forKey: 1250)
        dictionary.updateValue(["Brand Definition", "Custom Logo", "Responsive Website & 12 Months Hosting", "Comprehensive Results Tracking", "Monthly Marketing Strategy", "Staff Call Conversion Training (Phone Answering Skills)", "Referral System", "Targeted Postcard Mailer", "SEO"], forKey: 2250)
        dictionary.updateValue(["Brand Definition", "Custom Logo", "Responsive Website & 12 Months Hosting", "Comprehensive Results Tracking", "Monthly Marketing Strategy", "Staff Call Conversion Training (Phone Answering Skills)", "Referral System", "Targeted Mini-zine Mailer", "SEO"], forKey: 3250)
        dictionary.updateValue(["Brand Definition", "Custom Logo", "Responsive Website & 12 Months Hosting", "Comprehensive Results Tracking", "Monthly Marketing Strategy", "Staff Call Conversion Training (Phone Answering Skills)", "Referral System", "Targetd Mini-zine Mailer", "Open House Package", "SEO", "Internet Review Cards", "AdWords"], forKey: 4500)
        dictionary.updateValue(["Brand Definition", "Custom Logo", "Responsive Website & 12 Months Hosting", "Comprehensive Results Tracking", "Monthly Marketing Strategy", "Staff Call Conversion Training (Phone Answering Skills)", "Referral System", "Smile Savings System", "Targeted Mini-zine", "Open House Package", "SEO", "Internet Review Cards", "AdWords", "Facebook Jumpstart", "Facebook Outreach"], forKey: 5500)
        return dictionary
    }
    
    private static func assembleB2BDoctorsDictionary() -> Dictionary<Int,[String]> {
        var dictionary = Dictionary<Int,[String]>()
        dictionary.updateValue(["Referring Doctors - Option 1"], forKey: 750)
        dictionary.updateValue(["Referring Doctors - Option 2"], forKey: 1000)
        dictionary.updateValue(["Referring Doctors - Option 3"], forKey: 1500)
        return dictionary
    }
    
    private static func assembleB2BBothDictionary() -> Dictionary<Int,[String]> {
        var dictionary = Dictionary<Int,[String]>()
        dictionary.updateValue(["Both Referring Doctors & Patients - Option 1"], forKey: 750)
        dictionary.updateValue(["Both Referring Doctors & Patients - Option 2"], forKey: 2000)
        return dictionary
    }
}
/*
 
 ***EXTERNAL MARKETING***
 "8-Page Brochures"
 "Ad Design"
 "Adwords"
 "Brand Definition"
 "Call Training"
 "Door Hangers"
 "Email Campaign"
 "Facebook Jumpstart"
 "Facebook Outreach"
 "Internet Review"
 "Marketing Strategy"
 "Mini-Zine Mailer"
 "Movie Theater Ad"
 "Open House"
 "Postcard"
 "Radio Ad"
 "Result Tracking"
 "SEO"
 "Tri-fold Brochures"
 
 ***FOUNDATION***
 "Custom Logo" 175
 "Responsive Website" 500
 "Video & Photography" 750
 
 ***INTERNAL MARKETING***
 "Referral System" 150
 "Ancillary Services" 175
 "Case Acceptance" 750
 "Reactivation System" 175
 "Smile Savings System" 350
 
*/
