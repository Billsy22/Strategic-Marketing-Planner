//
//  BoxedLabel.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

@IBDesignable class BoxedLabel: UIView {
    
    @IBInspectable var text: String = "" {
        didSet {
            label.text = text
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
    
    private var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.removeFromSuperview()
        addSubview(label)
        label.removeConstraints(label.constraints)
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -insets.right).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -insets.bottom).isActive = true
        
        setNeedsLayout()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        var size: CGSize = CGSize.zero
        size.width = label.intrinsicContentSize.width + insets.left + insets.right
        size.height = label.intrinsicContentSize.height + insets.top + insets.bottom
        return size
    }

}
