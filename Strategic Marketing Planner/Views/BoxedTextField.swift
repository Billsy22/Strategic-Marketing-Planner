//
//  BoxedTextField.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/28/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

@IBDesignable class BoxedTextField: UIView {
    
    @IBInspectable var text: String = "" {
        didSet {
            textField.text = text
        }
    }
    
    var insets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            setup()
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var topInset: CGFloat  {
        get { return insets.top }
        set { insets.top = newValue }
    }
    
    @IBInspectable var rightInset: CGFloat {
        get { return insets.right }
        set { insets.right = newValue }
    }
    
    @IBInspectable var bottomInset: CGFloat {
        get { return insets.bottom }
        set { insets.bottom = newValue }
    }
    
    @IBInspectable var leftInset: CGFloat {
        get { return insets.left }
        set { insets.left = newValue }
    }
    
    private var textField: UITextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.removeFromSuperview()
        addSubview(textField)
        textField.removeConstraints(textField.constraints)
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left).isActive = true
        textField.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -insets.right).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -insets.bottom).isActive = true
        
        setNeedsLayout()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        var size: CGSize = CGSize.zero
        size.width = textField.intrinsicContentSize.width + insets.left + insets.right
        size.height = textField.intrinsicContentSize.height + insets.top + insets.bottom
        return size
    }
    
}
