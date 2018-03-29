//
//  GrowthCalculatorViewController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class GrowthCalculatorViewController: UIViewController {
    
    @IBOutlet weak var currentProductionTextfield: UITextField!
    @IBOutlet weak var productionGoalTextField: UITextField!
    
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
        currentProductionTextfield.setAsNumericKeyboard()
        productionGoalTextField.setAsNumericKeyboard()
        updateComputedValues()
        // Do any additional setup after loading the view.
    }

    func updateComputedValues(){
        desiredGrowthLabel.text = "\(desiredGrowth)"
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
