//
//  GrowthCalculatorViewController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class GrowthCalculatorViewController: UIViewController {
    
    // MARK: -  Properties and Outlets
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
    
    let growthCalc = GrowthCalculator()
    
    // MARK: -  Life Cycles
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
        annualMarketingBudgetTextField.delegate = self
        annualMarketingBudgetTextField.isEnabled = false
        lowEndReturnTextField.delegate = self
        lowEndReturnTextField.isEnabled = false
        highEndReturnTextField.delegate = self
        highEndReturnTextField.isEnabled = false
        averageReturnTextField.delegate = self
        averageReturnTextField.isEnabled = false
        estimatedGrowthTextField.delegate = self
        estimatedGrowthTextField.isEnabled = false

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateComputedValues()
    }

    // MARK: -  Update Views
    func updateComputedValues(){
        desiredGrowthTextField.text = "$\(Int(growthCalc.desiredGrowth))"
        annualMarketingBudgetTextField.text = "$\(Int(growthCalc.annualizedBudget))"
        lowEndReturnTextField.text = "$\(Int(growthCalc.lowEndReturn))"
        highEndReturnTextField.text = "$\(Int(growthCalc.highEndReturn))"
        averageReturnTextField.text = "$\(Int(growthCalc.averageReturn))"
        estimatedGrowthTextField.text = "\(growthCalc.growthPercentage)"
        updateGraphs()
    }
    
    func updateGraphs() {
        barGraphView.clearBarData()
        barGraphView.addBarData(data: growthCalc.averageReturn, dataLabelText: "Estimated Average Return", color: .returnGreen)
        barGraphView.addBarData(data: growthCalc.desiredGrowth, dataLabelText: "Desired Growth", color: .black)
        barGraphView.addBarData(data: growthCalc.productionGoal, dataLabelText: "12 Month\nProduction Goal", color: .goalBlue)
        barGraphView.addBarData(data: growthCalc.currentProduction, dataLabelText: "Current Production\n(Last 12 Months)", color: .currentBlue)
    }
    
    @IBAction func currentProductionEntered(_ sender: UITextField) {
        var text = sender.text
        text?.removeFirst()
        guard let valueAsString = text else { return }
        guard let value = Double(valueAsString) else {
            growthCalc.currentProduction = 0
            return
        }
        growthCalc.currentProduction = CGFloat(value)
        updateComputedValues()
    }
    
    @IBAction func productionGoalEntered(_ sender: UITextField) {
        var text = sender.text
        text?.removeFirst()
        guard let valueAsString = text else { return }
        guard let value = Double(valueAsString) else {
            growthCalc.productionGoal = 0
            return
        }
        growthCalc.productionGoal = CGFloat(value)
        updateComputedValues()
    }
    
    @IBAction func monthlyMarketingBudgetEntered(_ sender: UITextField) {
        var text = sender.text
        text?.removeFirst()
        guard let valueAsString = text else { return }
        guard let value = Double(valueAsString) else {
            growthCalc.monthlyBudget = 0
            return
        }
        growthCalc.monthlyBudget = CGFloat(value)
        updateComputedValues()
    }
}

// MARK: -  TextFieldDelegate and resign keyboard extension
extension GrowthCalculatorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.layoutIfNeeded()
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
