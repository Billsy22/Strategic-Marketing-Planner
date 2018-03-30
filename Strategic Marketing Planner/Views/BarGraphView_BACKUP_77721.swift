//
//  BarGraphView.swift
//  Strategic Marketing Planner
//
<<<<<<< HEAD
//  Created by Taylor Bills on 3/30/18.
=======
//  Created by Christopher Thiebaut on 3/28/18.
>>>>>>> development
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class BarGraphView: UIView {
    
<<<<<<< HEAD
    // MARK: -  Axis Properties
    var graphTransform: CGAffineTransform?
    var barDataArray: [BarData] = []
    var barsArray: [CAShapeLayer] = []
    var axisWidth: CGFloat = 2.0
    var axisColor: UIColor = .lightGray
    var showXAxisGraduations = true
    var labelFontSize: CGFloat = 10.0
    var axisLineWidth: CGFloat = 5

    // MARK: -  Bar Properties
    var barHeight: CGFloat = 10
    var minX: CGFloat = 0
    var maxX: CGFloat = 0
    var deltaX: CGFloat = 0
    var deltaY: CGFloat = 0
    var barSpacing: CGFloat = 5
    
    // MARK: -  Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -  SetUP Methods
    func setUpBarsForData() {
        for barData in barDataArray {
            let barLayer = CAShapeLayer()
            barLayer.fillColor = barData.dataColor.cgColor
            barLayer.strokeColor = barData.dataColor.cgColor
            barLayer.frame = frame
            barLayer.bounds = bounds
            layer.addSublayer(barLayer)
            barsArray.append(barLayer)
        }
    }
    
    func clearSublayers(layer: CALayer) {
        guard let sublayers = self.layer.sublayers else { return }
        for layer in sublayers {
            layer.removeFromSuperlayer()
        }
    }
    
    func updateAxisRange() {
        var xValues: [CGFloat] = []
        for barData in barDataArray {
            xValues.append(barData.data)
        }
        minX = xValues.min() ?? 0
        maxX = xValues.max() ?? 0
        var highestXValue = maxX
        var exponent: CGFloat = 0
        while highestXValue > 10 {
            highestXValue /= 10
            exponent += 1
        }
        let xValueRoundedUp = ceil(highestXValue)
        maxX = xValueRoundedUp * pow(10, exponent)
        deltaX = maxX / 4
        let biggestDataSeries = barDataArray.reduce(barDataArray[0]) { (largestSoFar, barDataSeries) -> BarData in
            let largerDataSeries = largestSoFar.data > barDataSeries.data ? largestSoFar : barDataSeries
            return largerDataSeries
        }
        deltaX =  maxX / CGFloat(biggestDataSeries.data)
        setTransform(minX: minX, maxX: maxX)
    }
    
    func setTransform(minX: CGFloat, maxX: CGFloat) {
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let xPadding = xLabelSize.height + 5
        let xScale = (bounds.width - xLabelSize.width/2 - 2)/(maxX - minX)
        let yScale = (bounds.height)
        graphTransform = CGAffineTransform(a: xScale, b: 0, c: 0, d: -yScale, tx: 1, ty: bounds.height - xPadding)
        setNeedsDisplay()
    }
    
    func plot() {
        guard let graphTransform = graphTransform else { updateAxisRange(); return }
        for index in 0..<barDataArray.count {
            let data = barDataArray[index].data
            let barLayer = barsArray[index]
            let barPath = CGMutablePath()
            barPath.addLine(to: CGPoint(x: data, y: 0), transform: graphTransform)
            barLayer.path = barPath
        }
    }
    
    func addBarData(data: CGFloat, color: UIColor) {
        let newBarData = BarData(data: data, dataColor: color)
        barDataArray.append(newBarData)
    }
    
    func drawAxes() {
        guard let graphTransform = graphTransform else { updateAxisRange(); return }
        let axisLine = CGMutablePath()
        let deltaXLines = CGMutablePath()
        let axisLayer = CAShapeLayer()
        let deltaXLayer = CAShapeLayer()
        axisLayer.frame = frame
        axisLayer.bounds = bounds
        deltaXLayer.frame = frame
        deltaXLayer.bounds = bounds
        axisLayer.strokeColor = axisColor.cgColor
        axisLayer.fillColor = UIColor.clear.cgColor
        deltaXLayer.strokeColor = axisColor.cgColor
        deltaXLayer.fillColor = UIColor.clear.cgColor
        axisLayer.lineWidth = axisLineWidth
        deltaXLayer.lineWidth = axisLineWidth / 2
        let xAxisPoints = [CGPoint(x: minX, y: 0), CGPoint(x: maxX, y: 0)]
        axisLine.addLines(between: xAxisPoints, transform: graphTransform)
        axisLayer.path = axisLine
        self.layer.addSublayer(axisLayer)
        for x in stride(from: minX, to: maxX, by: deltaX) {
            let points = [CGPoint(x: minX, y: 0), CGPoint(x: maxX, y: 0)]
            deltaXLines.addLines(between: points, transform: graphTransform)
            deltaXLayer.path = deltaXLines
            self.layer.addSublayer(deltaXLayer)
            let label = "\(Int(x))"
        }
    }
    
=======
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

>>>>>>> development
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

<<<<<<< HEAD
// MARK: -  Struct based on user input
struct BarData {
    
    var data: CGFloat
    var dataColor: UIColor = .blue
=======
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
>>>>>>> development
}
