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
    var legendRows: Int {
        let longestLabel = dataArray.reduce("") { (longestLabelSoFar, dataSeries) -> String in
            guard let currentLabel = dataSeries.dataLabelText else { return longestLabelSoFar }
            return longestLabelSoFar.count > currentLabel.count ? longestLabelSoFar : currentLabel
        }
        let legendEntryWidth = longestLabel.size(withSystemFontSize: labelFontSize).width + legendBlockWidth * 3
        let legendRowSpace = frame.size.width
        return max(Int(CGFloat(legendRowSpace)/legendEntryWidth), 1)
    }
    var legendHeight: CGFloat {
        return CGFloat((dataArray.filter( {$0.dataLabelText != nil} ).count / legendRows) + 1) * legendBlockWidth + 20
    }
    var legendBlockWidth: CGFloat = 10
    var internalHeight: CGFloat = 0
    var dataArray: [BarData] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: -  Bar Properties
    var barHeight: CGFloat = 25
    var minX: CGFloat = 0
    var maxX: CGFloat = 1
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
    var deltaX: CGFloat = 1
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
        for barData in dataArray {
            let barLayer = CAShapeLayer()
            barLayer.fillColor = barData.dataColor.cgColor
            barLayer.strokeColor = UIColor.clear.cgColor
            barLayer.lineWidth = 1
            barLayer.frame = CGRect(origin: CGPoint.zero, size: layer.frame.size)
            barLayer.zPosition = 1
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
    
    func clearBarData() {
        dataArray.removeAll()
        barsArray.removeAll()
    }
    
    func updateAxisRange() {
        var xValues: [CGFloat] = []
        for barData in dataArray {
            xValues.append(barData.data)
        }
        if xValues.max() == 0 {
            maxX = 1
        } else {
            maxX = xValues.max() ?? 1
            deltaX =  graphMaxValue / xGraduationCount
            setTransform(minX: minX, maxX: graphMaxValue)
        }
    }
    
    func setTransform(minX: CGFloat, maxX: CGFloat) {
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let xPadding = xLabelSize.height + 15
        let xScale = (bounds.width - xLabelSize.width/2 - 2)/(maxX - minX)
        let totalSpace = bounds.height - xPadding - legendHeight
        internalHeight = (barHeight * CGFloat(barsArray.count)) + (barSpacing * (CGFloat(barsArray.count) + 1))
        let yScale = totalSpace / internalHeight
        chartTransform = CGAffineTransform(a: xScale, b: 0, c: 0, d: -yScale, tx: 0, ty: totalSpace)
        setNeedsDisplay()
    }
    
    func plot() {
        guard let graphTransform = chartTransform else { updateAxisRange(); return }
        var barYSpacing: CGFloat = barSpacing
        for index in 0..<dataArray.count {
            let data = dataArray[index].data
            let barLayer = barsArray[index]
            let barPath = CGMutablePath()
            if data > 0 {
                let rect = CGRect(x: 0, y: barYSpacing, width: data, height: barHeight)
                barPath.addRect(rect, transform: graphTransform)
                barLayer.path = barPath
                barLayer.lineWidth = barHeight
                barYSpacing += barSpacing + barHeight
            } else {
                let rect = CGRect(x: 0, y: barYSpacing, width: 0, height: barHeight)
                barPath.addRect(rect, transform: graphTransform)
                barLayer.path = barPath
                barLayer.lineWidth = barHeight
                barYSpacing += barSpacing + barHeight
            }
        }
    }
    
    func addBarData(data: CGFloat, dataLabelText: String?, color: UIColor) {
        let newBarData = BarData(data: data, dataLabelText: dataLabelText, dataColor: color)
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
        for x in stride(from: minX, through: graphMaxValue, by: deltaX) {
            let points = [CGPoint(x: x, y: 0), CGPoint(x: x, y: internalHeight)]
            deltaXLayer.lineDashPattern = [3.0, 3.0]
            deltaXLines.addLines(between: points, transform: graphTransform)
            deltaXLayer.path = deltaXLines
            deltaXLayer.zPosition = 0
            self.layer.addSublayer(deltaXLayer)
            let label = "\(Int(x).shortenedUSDstring)" as NSString
            let labelSize = "\(Int(x).shortenedUSDstring)".size(withSystemFontSize: labelFontSize)
            var labelDrawPoint = CGPoint(x: x, y: 0).applying(graphTransform)
            labelDrawPoint.y += labelSize.height
            labelDrawPoint.x -= labelSize.width / 2
            label.draw(at: labelDrawPoint, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize), NSAttributedStringKey.foregroundColor: axisColor])
        }
        axisLayer.zPosition = 3
        self.layer.addSublayer(axisLayer)
    }
    
    override func draw(_ rect: CGRect) {
        clearSublayers(layer: layer)
        setUpBarsForData()
        updateAxisRange()
        drawAxes()
        plot()
        drawDataSeriesLabels()
    }
    
}

// MARK: -  Struct based on user input
struct BarData: GraphLegendData {
    var data: CGFloat
    var dataLabelText: String?
    var dataColor: UIColor
}
