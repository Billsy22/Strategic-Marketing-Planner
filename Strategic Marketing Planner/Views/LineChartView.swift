//
//  LineChartView.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 3/29/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class LineChartView: UIView {

    // MARK: -  Line and circle properties
    var linesAndCirclesArray: [(lineLayer: CAShapeLayer, circleLayer: CAShapeLayer)] = []
    var axesWidth: CGFloat = 2.0
    var circleWidth: CGFloat = 2.0
    var axisColor: UIColor = .black
    var showYAxisGraduations = true
    var labelFontSize: CGFloat = 10
    
    // MARK: -  Grid properties
    var dataArray: [DataSeries] = []{
        didSet {
            setNeedsDisplay()
        }
    }
    var chartTransform: CGAffineTransform?
    var axisLineWidth: CGFloat = 5
    var deltaX: CGFloat = 10
    var deltaY: CGFloat = 10
    var minX: CGFloat = 10
    var maxX: CGFloat = 10
    var minY: CGFloat = 10
    var maxY: CGFloat = 10
    
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
            layer.addSublayer(lineLayer)
            let circleLayer = CAShapeLayer()
            circleLayer.fillColor = dataSeries.dataColor.cgColor
            circleLayer.frame = CGRect(origin: CGPoint.zero, size: layer.frame.size)
            circleLayer.bounds = bounds
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
        maxY = roundedUp * pow(10, exponent)
        deltaY = maxY / 4
        let biggestDataSeries = dataArray.reduce(dataArray[0]) { (largestSoFar, dataSeries) -> DataSeries in
            let largerDataSeries = largestSoFar.data.count > dataSeries.data.count ? largestSoFar : dataSeries
            return largerDataSeries
        }
        deltaX =  maxX / CGFloat(biggestDataSeries.data.count)
        setTransform(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
    }
    
    
    func setTransform(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let yLabelSize = "\(Int(maxY))".size(withSystemFontSize: labelFontSize)
        let xPadding = xLabelSize.height + 2
        let yPadding = yLabelSize.width + 5
        let xScale = (bounds.width - yPadding - xLabelSize.width/2 - 2)/(maxX - minX)
        let yScale = (bounds.height - xPadding - yLabelSize.height/2 - 2)/(maxY - minY)
        chartTransform = CGAffineTransform(a: xScale, b: 0, c: 0, d: -yScale, tx: yPadding, ty: bounds.height - xPadding)
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
        }
    }
    
    func addDataSeries(points: [CGPoint], color: UIColor, labelText: String){
        let newDataSeries = DataSeries(data: points, dataColor: color, dataLabelText: labelText)
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
        
        for y in stride(from: minY, through: maxY, by: deltaY) {
            
            let points = [CGPoint(x: minX, y: y), CGPoint(x: maxX, y: y)]
            deltaYLines.addLines(between: points, transform: chartTransform)
            deltaYLayer.path = deltaYLines
            self.layer.addSublayer(deltaYLayer)
            if y != minY {
                let label = "\(Int(y))" as NSString
                let labelSize = "\(Int(y))".size(withSystemFontSize: labelFontSize)
                var labelDrawPoint = CGPoint(x: 0, y: y).applying(chartTransform)
                labelDrawPoint.x -= labelSize.width - 1
                labelDrawPoint.y -= labelSize.height/2
                label.draw(at: labelDrawPoint, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize), NSAttributedStringKey.foregroundColor: axisColor])
            }
        }
        
        for x in stride(from: minX, through: maxX, by: deltaX) {
            let label = "Year \(x)" as NSString
            let labelSize = "\(Int(x))".size(withSystemFontSize: labelFontSize)
            var labelDrawPoint = CGPoint(x: x, y: 0).applying(chartTransform)
            labelDrawPoint.x -= labelSize.width - 1
            labelDrawPoint.y -= labelSize.height/2
            label.draw(at: labelDrawPoint, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize), NSAttributedStringKey.foregroundColor: axisColor])
        }
    }
    
    
    
    
    
    
    
    // MARK: -  Draw
    override func draw(_ rect: CGRect) {
        clearSublayers(layer: layer)
        setUpLayersForData()
        updateAxisRange()
        drawAxes()
        plot()
    }
}

// MARK: -  DataSeries Struct
struct DataSeries {
    
    // MARK: -  Properties
    var data: [CGPoint]
    var dataColor: UIColor
    var dataLabelText: String
}

// MARK: -  Extension on string
extension String {
    // Get the size of a string and cast as NSString
    func size(withSystemFontSize pointSize: CGFloat) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: pointSize)])
    }
}
