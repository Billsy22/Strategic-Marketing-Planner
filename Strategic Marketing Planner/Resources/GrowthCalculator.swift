//
//  GrowthCalculator.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 4/2/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class GrowthCalculator {
    
    var currentProduction: CGFloat = 0.0
    var productionGoal: CGFloat = 0.0
    var monthlyBudget: CGFloat = 0.0
    
    var desiredGrowth: CGFloat {
        return productionGoal - currentProduction
    }
    
    var annualizedBudget: CGFloat {
        return monthlyBudget * 12
    }
    
    var lowEndReturn: CGFloat {
        var estimatedReturn: CGFloat
        
        if monthlyBudget < 1500 {
            estimatedReturn = annualizedBudget
        } else if monthlyBudget < 2500 {
            estimatedReturn = annualizedBudget * 1.5
        } else if monthlyBudget < 3500 {
            estimatedReturn = annualizedBudget * 2
        } else if monthlyBudget < 5000 {
            estimatedReturn = annualizedBudget * 2.5
        } else {
            estimatedReturn = annualizedBudget * 3
        }
        return estimatedReturn
    }
    
    var highEndReturn: CGFloat {
        var estimatedReturn: CGFloat
        
        if monthlyBudget < 1500 {
            estimatedReturn = annualizedBudget * 1.5
        } else if monthlyBudget < 2500 {
            estimatedReturn = annualizedBudget * 3
        } else if monthlyBudget < 3500 {
            estimatedReturn = annualizedBudget * 4
        } else if monthlyBudget < 5000 {
            estimatedReturn = annualizedBudget * 5
        } else {
            estimatedReturn = annualizedBudget * 6
        }
        return estimatedReturn
    }
    
    var averageReturn: CGFloat {
        return ((highEndReturn - lowEndReturn) / 2 + lowEndReturn)
    }
    
    var growthPercentage: CGFloat {
        if averageReturn == 0 || desiredGrowth == 0 {
            return 0.0
        } else {
        let growthLong = averageReturn / desiredGrowth
        let growthShort = round(100 * growthLong) / 100
        return growthShort
        }
    }
    
    var yearOneROI: [CGPoint] {
        let yearOne = CGPoint(x: 1, y: averageReturn)
        let yearTwo = CGPoint(x: 2, y: (yearOne.y)*0.85)
        let yearThree = CGPoint(x: 3, y: (yearTwo.y)*0.85)
        let yearFour = CGPoint(x: 4, y: (yearThree.y)*0.85)
        let yearFive = CGPoint(x: 5, y: (yearFour.y)*0.85)
        return[yearOne, yearTwo, yearThree, yearFour, yearFive]
    }
    
    var yearTwoROI: [CGPoint] {
        let yearTwo = CGPoint(x: 2, y: yearOneROI[0].y + yearOneROI[1].y)
        let yearThree = CGPoint(x: 3, y: yearOneROI[1].y + yearOneROI[2].y)
        let yearFour = CGPoint(x: 4, y: yearOneROI[2].y + yearOneROI[3].y)
        let yearFive = CGPoint(x: 5, y: yearOneROI[3].y + yearOneROI[4].y)
        return[yearTwo, yearThree, yearFour, yearFive]
    }
    
    var yearThreeROI: [CGPoint] {
        let yearThree = CGPoint(x: 3, y: yearOneROI[0].y + yearTwoROI[1].y)
        let yearFour = CGPoint(x: 4, y: yearOneROI[1].y + yearTwoROI[2].y)
        let yearFive = CGPoint(x: 5, y: yearOneROI[2].y + yearTwoROI[3].y)
        return[yearThree, yearFour, yearFive]
    }
    
    var yearFourROI: [CGPoint] {
        let yearFour = CGPoint(x: 4, y: yearOneROI[0].y + yearThreeROI[1].y)
        let yearFive = CGPoint(x: 5, y: yearOneROI[1].y + yearThreeROI[2].y)
        return[yearFour, yearFive]
    }
    
    var yearFiveROI: [CGPoint] {
        let yearFive = CGPoint(x: 5, y: yearOneROI[0].y + yearFourROI[1].y)
        return[yearFive]
    }
    
    var cumulativeROI: [CGPoint] {
        let yearOne = CGPoint(x: 1, y: yearOneROI[0].y)
        let yearTwo = CGPoint(x: 2, y: yearOneROI[0].y + yearOneROI[1].y)
        let yearThree = CGPoint(x: 3, y: yearOneROI[0].y + yearOneROI[1].y + yearOneROI[2].y)
        let yearFour = CGPoint(x: 4, y: yearOneROI[0].y + yearOneROI[1].y + yearOneROI[2].y + yearOneROI[3].y)
        let yearFive = CGPoint(x: 5, y: yearOneROI[0].y + yearOneROI[1].y + yearOneROI[2].y + yearOneROI[3].y + yearOneROI[4].y)
        return[yearOne, yearTwo, yearThree, yearFour, yearFive]
    }
    
    var yearlyInvestment: [CGPoint] {
        let yearOne = CGPoint(x: 1, y: annualizedBudget)
        let yearTwo = CGPoint(x: 2, y: annualizedBudget)
        let yearThree = CGPoint(x: 3, y: annualizedBudget)
        let yearFour = CGPoint(x: 4, y: annualizedBudget)
        let yearFive = CGPoint(x: 5, y: annualizedBudget)
        return[yearOne, yearTwo, yearThree, yearFour, yearFive]
    }
    
    var goal: [CGPoint] {
        let yearOne = CGPoint(x: 1, y: desiredGrowth)
        let yearTwo = CGPoint(x: 2, y: desiredGrowth)
        let yearThree = CGPoint(x: 3, y: desiredGrowth)
        let yearFour = CGPoint(x: 4, y: desiredGrowth)
        let yearFive = CGPoint(x: 5, y: desiredGrowth)
        return[yearOne, yearTwo, yearThree, yearFour, yearFive]
    }
}
