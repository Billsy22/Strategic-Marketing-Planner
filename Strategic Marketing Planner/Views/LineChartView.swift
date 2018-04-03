//
//  LineChartView.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 3/29/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class LineChartView: UIView, Graph {
    
    // MARK: -  Line and circle properties
    var linesAndCirclesArray: [(lineLayer: CAShapeLayer, circleLayer: CAShapeLayer)] = []
    var axesWidth: CGFloat = 2.0
    var circleWidth: CGFloat = 5
    var axisColor: UIColor = .black
    var showYAxisGraduations = true
    var labelFontSize: CGFloat = 10
    
    var xAxisGraduationsCount = 5
    var yAxisGraduationsCount = 4
    
    // MARK: -  Grid properties
    var dataArray: [DataSeries] = []{
        didSet {
            setNeedsDisplay()
        }
    }
    var chartTransform: CGAffineTransform?
    
    //The following 6 values are defaults which will be re-calculated before the graph is ever drawn.
    var deltaX: CGFloat = 10
    var deltaY: CGFloat = 10
    var minX: CGFloat = 10
    var maxX: CGFloat = 10
    var minY: CGFloat = 10
    var maxY: CGFloat = 10
    
    var legendBlockWidth: CGFloat = 10
    var legendHeight: CGFloat {
        return CGFloat((dataArray.filter({$0.dataLabelText != nil}).count / 3) + 1) * legendBlockWidth + 20
    }
    
    // MARK: -  Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpLayersForData() {
        for dataSeries in dataArray {
            let lineLayer = CAShapeLayer()
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.strokeColor = dataSeries.dataColor.cgColor
            lineLayer.frame = CGRect(origin: CGPoint.zero, size: layer.frame.size)
            lineLayer.bounds = bounds
            lineLayer.zPosition = 1
            layer.addSublayer(lineLayer)
            let circleLayer = CAShapeLayer()
            circleLayer.fillColor = dataSeries.dataColor.cgColor
            circleLayer.frame = CGRect(origin: CGPoint.zero, size: layer.frame.size)
            circleLayer.bounds = bounds
            circleLayer.zPosition = 1
            layer.addSublayer(circleLayer)
            linesAndCirclesArray.append((lineLayer, circleLayer))
        }
    }
    
    func clearSublayers(layer: CALayer){
        guard let sublayers = self.layer.sublayers else { return }
        for layer in sublayers {
            layer.removeFromSuperlayer()
        }
    }
    
    func updateAxisRange() {
        var xValues: [CGFloat] = []
        var yValues: [CGFloat] = []
        for data in dataArray {
            for point in data.data {
                xValues.append(point.x)
                yValues.append(point.y)
            }
        }
        maxY = yValues.max() ?? 0
        maxX = xValues.max() ?? 0
        minX = xValues.min() ?? 0
        minY = 0
        var highestYValue = maxY
        var exponent: CGFloat = 0
        while highestYValue > 10 {
            highestYValue /= 10
            exponent += 1
        }
        let roundedUp = ceil(highestYValue)
        let maxYcandidate = roundedUp * pow(10, exponent)
        maxY = maxYcandidate < maxY * 1.5 ? maxYcandidate : maxYcandidate * 0.75
        deltaY = maxY / CGFloat(yAxisGraduationsCount)
        deltaX =  floor(maxX / CGFloat(xAxisGraduationsCount))
        setTransform(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
    }
    
    
    func setTransform(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let yLabelSize = "\(Int(maxY))".size(withSystemFontSize: labelFontSize)
        let xPadding = xLabelSize.height * 2
        let yPadding = yLabelSize.width * 2
        let xScale = (bounds.width - yPadding - xLabelSize.width/2 - 2)/(maxX - minX)
        let yScale = (bounds.height - xPadding - legendHeight - yLabelSize.height/2 - 2)/(maxY - minY)
        chartTransform = CGAffineTransform(a: xScale, b: 0, c: 0, d: -yScale, tx: -(minX * xScale) + yPadding/2, ty: bounds.height - xPadding - legendHeight)
        setNeedsDisplay()
    }
    
    func plot() {
        guard let chartTransform = chartTransform else { updateAxisRange(); return }
        for index in 0..<dataArray.count {
            let dataPoints = dataArray[index].data
            let lineLayer = linesAndCirclesArray[index].lineLayer
            let linePath = CGMutablePath()
            linePath.addLines(between: dataPoints, transform: chartTransform)
            lineLayer.path = linePath
            let circleLayer = linesAndCirclesArray[index].circleLayer
            let circlePath = CGMutablePath()
            for point in dataPoints {
                let circleCenter = point.applying(chartTransform)
                circlePath.addEllipse(in: CGRect(x: circleCenter.x - circleWidth/2, y: circleCenter.y - circleWidth/2, width: circleWidth, height: circleWidth))
            }
            circleLayer.path = circlePath
            layer.addSublayer(circleLayer)
        }
    }
    
    func addDataSeries(points: [CGPoint], color: UIColor, labelText: String, showLines: Bool = true, showCircles: Bool = true){
        let newDataSeries = DataSeries(data: points, dataColor: color, dataLabelText: labelText, showLine: showLines, showCircles: showCircles)
        dataArray.append(newDataSeries)
    }
    
    func drawAxes() {
        guard let chartTransform = chartTransform else { updateAxisRange(); return }
        let axesLines = CGMutablePath()
        let deltaYLines = CGMutablePath()
        let axesLayer = CAShapeLayer()
        let deltaYLayer = CAShapeLayer()
        axesLayer.frame = CGRect(origin: CGPoint.zero, size: layer.frame.size)
        axesLayer.bounds = bounds
        deltaYLayer.frame = CGRect(origin: CGPoint.zero, size: layer.frame.size)
        deltaYLayer.bounds = bounds
        axesLayer.strokeColor = axisColor.cgColor
        axesLayer.fillColor = UIColor.clear.cgColor
        deltaYLayer.strokeColor = UIColor.lightGray.cgColor
        deltaYLayer.fillColor = UIColor.clear.cgColor
        axesLayer.lineWidth = axesWidth
        deltaYLayer.lineWidth = axesWidth / 2
        
        let xAxisPoints = [CGPoint(x: minX, y: 0), CGPoint(x: maxX, y: 0)]
        
        axesLines.addLines(between: xAxisPoints, transform: chartTransform)
        
        axesLayer.path = axesLines
        
        self.layer.addSublayer(axesLayer)
        
        guard showYAxisGraduations else { return }
        
        for y in stride(from: deltaY, through: maxY, by: deltaY) {
            
            let points = [CGPoint(x: minX, y: y), CGPoint(x: maxX, y: y)]
            deltaYLines.addLines(between: points, transform: chartTransform)
            deltaYLayer.lineDashPattern = [3,3]
            deltaYLayer.path = deltaYLines
            deltaYLayer.zPosition = 0
            self.layer.addSublayer(deltaYLayer)
            if y != minY {
                let label = "\(Int(y).shortenedUSDstring)" as NSString
                let labelSize = "\(Int(y))".size(withSystemFontSize: labelFontSize)
                var labelDrawPoint = CGPoint(x: 0, y: y).applying(chartTransform)
                labelDrawPoint.x -= chartTransform.tx //- labelSize.width - 1
                labelDrawPoint.y -= labelSize.height/2
                label.draw(at: labelDrawPoint, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize), NSAttributedStringKey.foregroundColor: axisColor])
            }
        }
        
        for x in stride(from: minX, through: maxX, by: deltaX) {
            let label = "Year \(Int(x))"
            let labelSize = label.size(withSystemFontSize: labelFontSize)
            var labelDrawPoint = CGPoint(x: x, y: 0).applying(chartTransform)
            labelDrawPoint.x -= labelSize.width/2
            labelDrawPoint.y += labelSize.height
            label.draw(at: labelDrawPoint, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize), NSAttributedStringKey.foregroundColor: axisColor])
        }
    }
    
    // MARK: -  Draw
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clearSublayers(layer: layer)
        setUpLayersForData()
        updateAxisRange()
        drawAxes()
        plot()
        drawDataSeriesLabels()
    }
    
}

// MARK: -  DataSeries Struct

protocol GraphLegendData {
    var dataLabelText: String? { get }
    var dataColor: UIColor { get }
}

struct DataSeries: GraphLegendData {
    
    // MARK: -  Properties
    var data: [CGPoint]
    var dataColor: UIColor
    var dataLabelText: String?
    var showLine: Bool = true
    var showCircles: Bool = true
}

// MARK: -  Extension on string
extension String {
    // Get the size of a string and cast as NSString
    func size(withSystemFontSize pointSize: CGFloat) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: pointSize)])
    }
}

extension Int {
    
    var shortenedUSDstring: String {
        return self > 1000 ? "$\(self/1000)k" : "$\(self)"
    }
}

protocol Graph: class {
    var chartTransform: CGAffineTransform? { get }
    var legendBlockWidth: CGFloat { get }
    var legendHeight: CGFloat { get }
    var minX: CGFloat { get }
    associatedtype  GraphData: GraphLegendData
    var dataArray: [GraphData] { get }
    var labelFontSize: CGFloat { get }
    var axisColor: UIColor { get }
}

extension Graph where Self: UIView {
    func drawDataSeriesLabels() {
        guard let chartTransform = chartTransform else {
            //updateAxisRange()
            return
        }
        let blockWidth: CGFloat = legendBlockWidth
        var nextBlockPosition = CGPoint.init(x: minX, y: 0).applying(chartTransform)
        
        nextBlockPosition.x += blockWidth
        nextBlockPosition.y = bounds.height - legendHeight
        
        let longestLabel = dataArray.reduce("") { (longestLabelSoFar, dataSeries) -> String in
            guard let currentLabel = dataSeries.dataLabelText else { return longestLabelSoFar }
            return longestLabelSoFar.count > currentLabel.count ? longestLabelSoFar : currentLabel
        }
        
        let labelSize = longestLabel.size(withSystemFontSize: labelFontSize)
        
        for dataSeries in dataArray.filter({$0.dataLabelText != nil}) {
            let labelText = dataSeries.dataLabelText ?? ""
            
            let labelLayer = CAShapeLayer()
            labelLayer.fillColor = dataSeries.dataColor.cgColor
            let path = CGMutablePath()
            var labelPosition = CGPoint(x: nextBlockPosition.x + 2, y: nextBlockPosition.y + labelSize.height - 2)
            
            if labelPosition.x + labelSize.width > bounds.maxX {
                var nextRowBlockPosition = CGPoint(x: minX, y: 0).applying(chartTransform)
                nextRowBlockPosition.x += blockWidth
                nextBlockPosition.x = nextRowBlockPosition.x
                nextBlockPosition.y += blockWidth + 5
                labelPosition = CGPoint(x: nextBlockPosition.x + 2, y: nextBlockPosition.y + labelSize.height - 2)
            }
            
            let colorBlock = CGRect(x: nextBlockPosition.x - blockWidth, y: nextBlockPosition.y + blockWidth, width: blockWidth, height: blockWidth)
            path.addRect(colorBlock)
            labelLayer.path = path
            layer.addSublayer(labelLayer)
            labelText.draw(at: labelPosition, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize), NSAttributedStringKey.foregroundColor: axisColor])
            nextBlockPosition.x = labelPosition.x + labelSize.width + 2 * blockWidth
        }
    }
}
