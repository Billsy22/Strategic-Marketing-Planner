//
//  NumericKeyboard.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/28/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

protocol NumericKeyboardDelegate: class {
    func digitPressed(digit: Int)
    func backspacePressed()
    func donePressed()
}

extension UITextField: NumericKeyboardDelegate {
    
    func digitPressed(digit: Int) {
        if self.text == "$0" { self.text = "$" }
        self.text?.append("\(digit)")
    }
    
    func backspacePressed() {
        guard var text = self.text, text.count > 0 else { return }
        guard text.last != "$" else { return }
        _ = text.removeLast()
        self.text = text
    }
    
    func donePressed() {
        if let textFieldShouldReturn = delegate?.textFieldShouldReturn {
            _ = textFieldShouldReturn(self)
        }
    }
    
    func setAsNumericKeyboard(){
        if text?.first != "$" {
            text?.insert("$", at: text!.startIndex)
        }
        let numericKeyboard = NumericKeyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        self.inputView = numericKeyboard
        numericKeyboard.delegate = self
    }
    
    func unsetNumericKeyboard(){
        if text?.first == "$" {
            text?.removeFirst()
        }
        if let numericKeyboard = self.inputView as? NumericKeyboard {
            numericKeyboard.delegate = nil
            self.inputView = nil
        }
    }
    
    
}

class NumericKeyboard: UIView {

    weak var delegate: NumericKeyboardDelegate?
    
    private let xibFileName = "NumericKeyboard"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeKeyboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeKeyboard()
    }
    
    func initializeKeyboard() {
        guard let xibUI = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil), let view = xibUI[0] as? UIView else {
            fatalError("Failed to initialize numberic keyboard from xib.")
        }
        addSubview(view)
        view.frame = bounds
    }
    
    @IBAction func digitTapped(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text, let number = Double(text) else {
            return
        }
        delegate?.digitPressed(digit: Int(number))
    }
    
    @IBAction func backspacePressed(_ sender: UIButton) {
        delegate?.backspacePressed()
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        delegate?.donePressed()
    }
}
