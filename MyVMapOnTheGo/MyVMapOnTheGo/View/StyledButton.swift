//
//  StyledButton.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 11/10/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//

import UIKit

class StyledButton : UIButton {
    
    // MARK: Properties
    
    // constants for styling and configuration
    let darkerBlue = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
    let lighterBlue = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    let titleLabelFontSize: CGFloat = 17.0
    let styledButtonHeight: CGFloat = 44.0
    let styledButtonCornerRadius: CGFloat = 4.0
    let phoneStyledButtonExtraPadding: CGFloat = 14.0
    
    var backingColor: UIColor? = nil
    var highlightedBackingColor: UIColor? = nil
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        themeStyledButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        themeStyledButton()
    }
    
    private func themeStyledButton() {
        layer.masksToBounds = true
        layer.cornerRadius = styledButtonCornerRadius
        highlightedBackingColor = darkerBlue
        backingColor = lighterBlue
        backgroundColor = lighterBlue
        setTitleColor(.white, for: UIControl.State())
        titleLabel?.font = UIFont.systemFont(ofSize: titleLabelFontSize)
    }
    
    // MARK: Setters
    
    private func setBackingColor(_ newBackingColor: UIColor) {
        if let _ = backingColor {
            backingColor = newBackingColor
            backgroundColor = newBackingColor
        }
    }
    
    private func setHighlightedBackingColor(_ newHighlightedBackingColor: UIColor) {
        highlightedBackingColor = newHighlightedBackingColor
        backingColor = highlightedBackingColor
    }
    
    // MARK: Tracking
    
    override func beginTracking(_ touch: UITouch, with withEvent: UIEvent?) -> Bool {
        backgroundColor = highlightedBackingColor
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func cancelTracking(with event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    // MARK: Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let extraButtonPadding : CGFloat = phoneStyledButtonExtraPadding
        var sizeThatFits = CGSize.zero
        sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
        sizeThatFits.height = styledButtonHeight
        return sizeThatFits
    }
}
