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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restoreState()
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
        barGraphView.addBarData(data: growthCalc.productionGoal, dataLabelText: "12 Month Production Goal", color: .goalBlue)
        barGraphView.addBarData(data: growthCalc.currentProduction, dataLabelText: "Current Production(Last 12 Months)", color: .currentBlue)
        lineChartView.clearLineData()
        lineChartView.addDataSeries(points: growthCalc.goal, color: .black, labelText: "Goal", showLines: true, showCircles: false)
        lineChartView.addDataSeries(points: growthCalc.cumulativeROI, color: .goalBlue, labelText: "Cululative ROI", showLines: true)
        lineChartView.addDataSeries(points: growthCalc.yearlyInvestment, color: .lightGray, labelText: "Yearly Investment", showLines: false)
        lineChartView.addDataSeries(points: growthCalc.yearOneROI, color: .returnGreen, labelText: "Yr 1 - Annual ROI", showLines: true)
        lineChartView.addDataSeries(points: growthCalc.yearTwoROI, color: .returnGreen, labelText: "Yr 2 - Annual ROI", showLines:  true)
        lineChartView.addDataSeries(points: growthCalc.yearThreeROI, color: .returnGreen, labelText: "Yr 3 - Annual ROI", showLines: true)
        lineChartView.addDataSeries(points: growthCalc.yearFourROI, color: .returnGreen, labelText: "Yr 4 - Annual ROI", showLines: true)
        lineChartView.addDataSeries(points: growthCalc.yearFiveROI, color: .returnGreen, labelText: "Yr 5 - Annual ROI", showLines: true)
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
        let budgetAsDecimal = Decimal(value)
        guard let client = ClientController.shared.currentClient else { return }
        ClientController.shared.updateMonthlyBudget(for: client, withAmount: NSDecimalNumber(decimal: budgetAsDecimal))
    }
    
    private func restoreState(){
        guard let client = ClientController.shared.currentClient, let monthlyBudget = client.monthlyBudget, let currentProduction = client.currentProduction, let productionGoal = client.productionGoal else { return }
        monthlyMarketingBudgetTextField.text = "$\(monthlyBudget)"
        monthlyMarketingBudgetEntered(monthlyMarketingBudgetTextField)
        //growthCalc.monthlyBudget = CGFloat(truncating: monthlyBudget)
        currentProductionTextField.text = "$\(currentProduction)"
        currentProductionEntered(currentProductionTextField)
        //growthCalc.currentProduction = CGFloat(truncating: currentProduction)
        productionGoalTextField.text = "$\(productionGoal)"
        productionGoalEntered(productionGoalTextField)
//        growthCalc.productionGoal = CGFloat(truncating: productionGoal)
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
