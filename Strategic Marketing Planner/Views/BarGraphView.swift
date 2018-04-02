//
//  BarGraphView.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 3/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class BarGraphView: UIView, Graph {
    
    // MARK: -  Axis Properties
    var barsArray: [CAShapeLayer] = []
    var axisWidth: CGFloat = 5
    var showXAxisGraduations = true
    var labelFontSize: CGFloat = 10.0
    var chartTransform: CGAffineTransform?
    var axisColor: UIColor = .black
    var deltaXColor: UIColor = .lightGray
    var axisLineWidth: CGFloat = 2
    var xGraduationCount: CGFloat = 4
    var legendHeight: CGFloat = 5
    var legendBlockWidth: CGFloat = 5
    var internalHeight: CGFloat {
        return (barHeight * CGFloat(barsArray.count)) + (barSpacing * CGFloat((barsArray.count + 1)))
    }
    var dataArray: [BarData] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: -  Bar Properties
    var barHeight: CGFloat = 25
    var minX: CGFloat = 0
    var maxX: CGFloat = 0
    var graphMaxValue: CGFloat {
        var highestXValue = maxX
        var exponent: CGFloat = 0
        while highestXValue > 10 {
            highestXValue /= 10
            exponent += 1
        }
        let xValueRoundedUp = ceil(highestXValue)
        return xValueRoundedUp * pow(10, exponent)
    }
    var deltaX: CGFloat = 0
    var barSpacing: CGFloat = 10
    
    // MARK: -  Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -  SetUP Methods
    func setUpBarsForData() {
        for barData in dataArray {
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
        for barData in dataArray {
            xValues.append(barData.data)
        }
        maxX = xValues.max() ?? 0
        deltaX =  graphMaxValue / xGraduationCount
        setTransform(minX: minX, maxX: graphMaxValue)
    }
    
    func setTransform(minX: CGFloat, maxX: CGFloat) {
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let xPadding = xLabelSize.height + 15
        let xScale = (bounds.width - xLabelSize.width/2 - 2)/(maxX - minX)
        let totalSpace = bounds.height - xPadding
        let yScale = totalSpace / internalHeight
        chartTransform = CGAffineTransform(a: xScale, b: 0, c: 0, d: -yScale, tx: 0, ty: bounds.height - xPadding)
        barHeight = barHeight * yScale
        setNeedsDisplay()
    }
    
    func plot() {
        guard let graphTransform = chartTransform else { updateAxisRange(); return }
        var barYSpacing: CGFloat = barSpacing
        for index in 0..<dataArray.count {
            let data = dataArray[index].data
            let barLayer = barsArray[index]
            let barPath = CGMutablePath()
            barPath.addLines(between: [CGPoint(x: 0 ,y:  barYSpacing + barHeight/2), CGPoint(x: data, y: barYSpacing + barHeight/2)], transform: graphTransform)
            barLayer.path = barPath
            barYSpacing += barSpacing + barHeight/2
        }
    }
    
    func addBarData(data: CGFloat, color: UIColor) {
        let newBarData = BarData(data: data, dataLabelText: "The brand", dataColor: color)
        dataArray.append(newBarData)
    }
    
    func drawAxes() {
        guard let graphTransform = chartTransform else { updateAxisRange(); return }
        let axisLine = CGMutablePath()
        let deltaXLines = CGMutablePath()
        let axisLayer = CAShapeLayer()
        let deltaXLayer = CAShapeLayer()
        axisLayer.frame = CGRect(origin: CGPoint.zero, size: layer.frame.size)
        axisLayer.bounds = bounds
        deltaXLayer.frame = CGRect(origin: CGPoint.zero, size: layer.frame.size)
        deltaXLayer.bounds = bounds
        axisLayer.strokeColor = axisColor.cgColor
        axisLayer.fillColor = UIColor.clear.cgColor
        deltaXLayer.strokeColor = deltaXColor.cgColor
        deltaXLayer.fillColor = UIColor.clear.cgColor
        axisLayer.lineWidth = axisLineWidth
        deltaXLayer.lineWidth = axisLineWidth / 2
        let yAxisPoints = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: internalHeight)]
        axisLine.addLines(between: yAxisPoints, transform: graphTransform)
        axisLayer.path = axisLine
        self.layer.addSublayer(axisLayer)
        for x in stride(from: minX, through: graphMaxValue, by: deltaX) {
            let points = [CGPoint(x: x, y: 0), CGPoint(x: x, y: internalHeight)]
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
struct BarData: GraphLegendData {
    var data: CGFloat
    var dataLabelText: String?
    var dataColor: UIColor
}
