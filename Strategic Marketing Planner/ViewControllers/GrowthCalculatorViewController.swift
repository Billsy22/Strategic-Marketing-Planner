//
//  GrowthCalculatorViewController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class GrowthCalculatorViewController: UIViewController {
    


    @IBOutlet weak var currentProductionTextField: UITextField!
    @IBOutlet weak var productionGoalTextField: UITextField!
    @IBOutlet weak var desiredGrowthTextField: UITextField!
    @IBOutlet weak var monthlyMarketingBudgetTextField: UITextField!
    @IBOutlet weak var annualMarketingBudgetTextField: UITextField!
    @IBOutlet weak var lowEndReturnTextField: UITextField!
    @IBOutlet weak var highEndReturnTextField: UITextField!
    @IBOutlet weak var averageReturnTextField: UITextField!
    @IBOutlet weak var estimatedGrowthTextField: UITextField!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var barGraphView: BarGraphView!
    
    var currentProduction: Decimal = 0 {
        didSet {
            updateComputedValues()
        }
    }
    var productionGoal: Decimal = 0 {
        didSet {
            updateComputedValues()
        }
    }
    var desiredGrowth: Decimal { return productionGoal - currentProduction }

    @IBOutlet weak var desiredGrowthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentProductionTextField.delegate = self
        currentProductionTextField.setAsNumericKeyboard()
        productionGoalTextField.delegate = self
        productionGoalTextField.setAsNumericKeyboard()
        desiredGrowthTextField.delegate = self
        desiredGrowthTextField.isEnabled = false
        monthlyMarketingBudgetTextField.delegate = self
        monthlyMarketingBudgetTextField.setAsNumericKeyboard()
        var points: [CGPoint] = []
        for position in 1...5 {
            let newPoint = CGPoint(x: position, y: 100_001 * position)
            points.append(newPoint)
        }
        var morePoints: [CGPoint] = []
        for position in 1...5 {
            let newPoint = CGPoint(x: position, y: 150_000 * position)
            morePoints.append(newPoint)
        }
        var points2: [CGPoint] = []
        for position in 1...5 {
            let newPoint = CGPoint(x: position, y: 110_001 * position)
            points2.append(newPoint)
        }
        var points3: [CGPoint] = []
        for position in 1...5 {
            let newPoint = CGPoint(x: position, y: 110_001 * position)
            points3.append(newPoint)
        }

        lineChartView.addDataSeries(points: points, color: .blue, labelText: "Cumulative Return")
        lineChartView.addDataSeries(points: morePoints, color: .black, labelText: "Desired Growth")
        lineChartView.addDataSeries(points: points2, color: .green, labelText: "Another Series")
        lineChartView.addDataSeries(points: points2, color: .green, labelText: "Yet Another Series")
        
        let data: CGFloat = 99
        let moreData: CGFloat = 25
        let littleData: CGFloat = 24
        let theLastTestData: CGFloat = 74
        barGraphView.addBarData(data: theLastTestData, dataLabelText: "theLastTestData", color: .black)
        barGraphView.addBarData(data: moreData, dataLabelText: "More Data", color: .blue)
        barGraphView.addBarData(data: littleData, dataLabelText: "little data", color: .green)
        barGraphView.addBarData(data: data, dataLabelText: "data", color: .red)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateComputedValues()
    }

    func updateComputedValues(){
        desiredGrowthTextField.text = "\(desiredGrowth)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func currentProductionEntered(_ sender: UITextField) {
        guard let text = sender.text, let value = Decimal(string: text) else {
            currentProduction = 0
            return
        }
        currentProduction = value
    }
    
    @IBAction func productionGoalEntered(_ sender: UITextField) {
        guard let text = sender.text, let value = Decimal(string: text) else {
            productionGoal = 0
            return
        }
        productionGoal = value
    }
}

extension GrowthCalculatorViewController: UITextFieldDelegate {

}
