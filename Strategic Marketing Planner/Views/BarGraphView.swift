//
//  BarGraphView.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 3/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class BarGraphView: UIView {
    
    // MARK: -  Axis Properties
    var barsArray: [CAShapeLayer] = []
    var axisWidth: CGFloat = 8
    var showXAxisGraduations = true
    var labelFontSize: CGFloat = 10.0
    var graphTransform: CGAffineTransform?
    var axisColor: UIColor = .lightGray
    var axisLineWidth: CGFloat = 5
    var xGraduationCount: CGFloat = 5
    var barDataArray: [BarData] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: -  Bar Properties
    var barHeight: CGFloat = 25
    var minX: CGFloat = 0
    var maxX: CGFloat = 0
    var deltaX: CGFloat = 0
    var deltaY: CGFloat = 0
    var barSpacing: CGFloat = 40
    
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
            barLayer.fillColor = UIColor.clear.cgColor
            barLayer.strokeColor = barData.dataColor.cgColor
            barLayer.lineWidth = barHeight
            barLayer.frame = CGRect(origin: CGPoint.zero, size: layer.frame.size)
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
        maxX = xValues.max() ?? 0
        var highestXValue = maxX
        var exponent: CGFloat = 0
        while highestXValue > 10 {
            highestXValue /= 10
            exponent += 1
        }
        let xValueRoundedUp = ceil(highestXValue)
        let maxXCandidate = xValueRoundedUp * pow(10, exponent)
        maxX = maxXCandidate < maxX * 1.5 ? maxXCandidate : maxXCandidate * 0.75
        deltaX =  maxX / xGraduationCount
        setTransform(minX: minX, maxX: maxX)
    }
    
    func setTransform(minX: CGFloat, maxX: CGFloat) {
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let xPadding = xLabelSize.height + 5
        let xScale = (bounds.width - xLabelSize.width/2 - 2)/(maxX - minX)
        let yScale: CGFloat = 1
        graphTransform = CGAffineTransform(a: xScale, b: 0, c: 0, d: -yScale, tx: 1, ty: bounds.height - xPadding)
        setNeedsDisplay()
    }
    
    func plot() {
        guard let graphTransform = graphTransform else { updateAxisRange(); return }
        var barYPosition: CGFloat = 0
        for index in 0..<barDataArray.count {
            let data = barDataArray[index].data
            let barLayer = barsArray[index]
            let barPath = CGMutablePath()
            barPath.addLines(between: [CGPoint(x: 0 ,y: barYPosition), CGPoint(x: data, y: barYPosition)], transform: graphTransform)
            barLayer.path = barPath
            barYPosition += barSpacing
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
            let label = "\(Int(x).shortenedUSDstring)" as NSString
            let labelSize = "\(Int(x).shortenedUSDstring)".size(withSystemFontSize: labelFontSize)
            var labelDrawPoint = CGPoint(x: x, y: 0).applying(graphTransform)
            labelDrawPoint.y += labelSize.height
            label.draw(at: labelDrawPoint, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize), NSAttributedStringKey.foregroundColor: axisColor])
        }
    }
    
    override func draw(_ rect: CGRect) {
        clearSublayers(layer: layer)
        setUpBarsForData()
        updateAxisRange()
        drawAxes()
        plot()
    }
    
}

// MARK: -  Struct based on user input
struct BarData {
    
    var data: CGFloat
    var dataColor: UIColor
}
