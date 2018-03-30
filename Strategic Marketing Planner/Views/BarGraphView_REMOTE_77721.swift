//
//  BarGraphView.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/28/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class BarGraphView: UIView {
    
    var data: [BarGraphData] = []
    
    var max: Double {
        return data.max()?.value ?? 0
    }
    
    var min: Double {
        return data.min()?.value ?? 0
    }
    
    func addData(_ data: BarGraphData){
        self.data.append(data)
        redrawGraph()
    }
    
    func redrawGraph(){
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

struct BarGraphData: Comparable {
    
    var value: Double
    var color: UIColor
    var label: String
    
    static func <(lhs: BarGraphData, rhs: BarGraphData) -> Bool {
        return lhs.value < rhs.value
    }
    
    static func ==(lhs: BarGraphData, rhs: BarGraphData) -> Bool {
        return lhs.value == rhs.value
    }
}
