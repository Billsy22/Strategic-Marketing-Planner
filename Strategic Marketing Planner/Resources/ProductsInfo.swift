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
    
    static let urbanKey = MarketingPlan.ExternalMarketingFocus.digital.rawValue
    static let suburbanKey = MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue
    static let ruralKey = MarketingPlan.ExternalMarketingFocus.traditional.rawValue
    
    static let urbanValue = assembleUrbanDictionary()
    static let suburbanValue = assembleSuburbanDictionary()
    static let ruralValue = assembleRuralDictionary()
    
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
}
    /*
    static let ruralOne = [MarketingPlan.ExternalMarketingFocus.traditional.rawValue : [500 : ["Ad Design", "Tri-fold Brochures"]]]
    static let ruralTwo = [MarketingPlan.ExternalMarketingFocus.traditional.rawValue : [1000 : ["Door Hangers", "Ad Design", "Movie Theater Ad", "Tri-fold Brochures"]]]
    static let ruralThree = [MarketingPlan.ExternalMarketingFocus.traditional.rawValue : [1500 : ["Postcard", "Ad Design", "Tri-fold Brochures"]]]
    static let ruralFour = [MarketingPlan.ExternalMarketingFocus.traditional.rawValue : [2000 : ["Results Tracking", "Marketing Strategy", "Postcard", "Ad Design", "Tri-fold Brochures"]]]
    static let ruralFive = [MarketingPlan.ExternalMarketingFocus.traditional.rawValue : [2500 : ["Results Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "8-Page Brochures"]]]
    static let ruralSix = [MarketingPlan.ExternalMarketingFocus.traditional.rawValue : [3000 : ["Results Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Tri-fold Brochures"]]]
    static let ruralSeven =  [MarketingPlan.ExternalMarketingFocus.traditional.rawValue : [3500 : ["Results Tracking", "Marketing Strategy", "Postcard", "Ad Design", "Tri-fold Brochures"]]]
    static let ruralEight =  [MarketingPlan.ExternalMarketingFocus.traditional.rawValue : [4000 : ["Results Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Radio Ad", "Movie Theater Ad", "8-Page Brochures"]]]
    static let ruralNine =  [MarketingPlan.ExternalMarketingFocus.traditional.rawValue : [5000 : ["Results Tracking", "Marketing Strategy", "Postcard", "Mini-Zine Mailer", "Ad Design", "Radio Ad", "Movie Theater Ad", "8-Page Brochures"]]]
    static let ruralTen =  [MarketingPlan.ExternalMarketingFocus.traditional.rawValue : [6000 : ["Results Tracking", "Marketing Strategy", "Postcard", "Mini-Zine Mailer", "Ad Design", "Radio Ad", "Movie Theater Ad", "8-Page Brochures"]]]
    
    static let urbanOne = [MarketingPlan.ExternalMarketingFocus.digital.rawValue : [750 : ["SEO", "Internet Review", "Facebook Outreach"]]]
    static let urbanTwo = [MarketingPlan.ExternalMarketingFocus.digital.rawValue : [1750 : ["SEO", "AdWords", "Email Campaign", "Facebook Jumpstart", "Facebook Outreach"]]]
    static let urbanThree = [MarketingPlan.ExternalMarketingFocus.digital.rawValue : [2750 : ["Results Tracking", "Marketing Strategy", "SEO", "Internet Review", "AdWords", "Email Campaign", "Facebook Jumpstart", "Facebook Outreach"]]]
    static let urbanFour = [MarketingPlan.ExternalMarketingFocus.digital.rawValue : [3750 : ["Results Tracking", "Marketing Strategy", "SEO", "Internet Review", "AdWords", "Email Campaign", "Facebook Jumpstart", "Facebook Outreach"]]]
    static let urbanFive = [MarketingPlan.ExternalMarketingFocus.digital.rawValue : [4750 : ["Results Tracking", "Marketing Strategy", "SEO", "Internet Review", "AdWords", "Email Campaign", "Facebook Jumpstart", "Facebook Outreach"]]]
    
    static let suburbanOne = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [500 : ["Ad Design", "Tri-fold Brochures", "SEO"]]]
    static let suburbanTwo = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [1000 : ["Ad Design", "Tri-fold Brochures", "SEO", "Internet Review", "Facebook Jumpstart"]]]
    static let suburbanThree = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [1500 : ["Postcard", "SEO", "Internet Review"]]]
    static let suburbanFour = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [2000 : ["Result Tracking", "Marketing Strategy", "Postcard", "Tri-fold Brochures", "Ad Design", "Movie Theater Ad"]]]
    static let suburbanFive = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [2500 : ["Result Tracking", "Marketing Strategy", "Postcard", "SEO", "Internet Review", "Adwords", "Facebook Outreach"]]]
    static let suburbanSix = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [3000 : ["Result Tracking", "Marketing Strategy", "Postcard", "Tri-fold Brochures", "Ad Design", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"]]]
    static let suburbanSeven = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [3500 : ["Result Tracking", "Marketing Strategy", "Postcard", "Ad Design", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"]]]
    static let suburbanEight = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [4000 : ["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Tri-fold Brochures", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"]]]
    static let suburbanNine = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [4500 : ["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "SEO", "Internet Review", "Adwords", "Facebook Outreach"]]]
    static let suburbanTen = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [5000 : ["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Tri-fold Brochures", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"]]]
    static let suburbanEleven = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [5500 : ["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Movie Theater Ad", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"]]]
    static let suburbanTwelve = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [6000 : ["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Movie Theater Ad", "Tri-fold Brochures", "SEO", "Internet Review", "Adwords", "Email Campaign", "Facebook Jumpstart", "Facebook Outreach"]]]
    static let suburbanThirteen = [MarketingPlan.ExternalMarketingFocus.digitalTraditionalMix.rawValue : [6500 : ["Result Tracking", "Marketing Strategy", "Mini-Zine Mailer", "Ad Design", "Movie Theater Ad", "Tri-fold Brochures", "SEO", "Internet Review", "Adwords", "Facebook Jumpstart", "Facebook Outreach"]]]

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
 "Video & Photo" 750
 
 ***INTERNAL MARKETING***
 "Referral System" 150
 "Ancillary Services" 175
 "Case Acceptance" 750
 "Reactivation System" 175
 "Smile Savings System" 350
 */
