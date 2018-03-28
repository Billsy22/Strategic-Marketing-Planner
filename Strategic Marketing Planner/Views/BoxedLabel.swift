//
//  BoxedLabel.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

@IBDesignable class BoxedLabel: UILabel {
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize(); setNeedsDisplay() }
    }
    
    @IBInspectable var topInset: CGFloat {
        get { return textInsets.top }
        set { textInsets.top = newValue }
    }
    @IBInspectable var rightInset: CGFloat {
        get { return textInsets.right }
        set { textInsets.right = newValue }
    }
    @IBInspectable var bottomInset: CGFloat {
        get { return textInsets.bottom }
        set { textInsets.bottom = newValue }
    }
    @IBInspectable var leftInset: CGFloat {
        get { return textInsets.left }
        set { textInsets.left = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInsets(top: topInset, right: rightInset, bottom: bottomInset, left: leftInset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setInsets(top: topInset, right: rightInset, bottom: bottomInset, left: leftInset)
    }
    
    private func setInsets(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat){
        topInset = top
        rightInset = right
        bottomInset = bottom
        leftInset = left
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += textInsets.left + textInsets.right
        size.height += textInsets.top + textInsets.bottom
        return size
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
        sizeToFit()
    }
    

}
