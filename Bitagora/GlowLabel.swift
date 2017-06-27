//
//  GlowLabel.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 16/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class GlowLabel: UILabel {
    
    // MARK: properties
    @IBInspectable public var glowColor: UIColor = .clear {
        didSet { updateLabel() }
    }
    
    @IBInspectable public var glowOffset: CGSize = CGSize(width: 0, height:0) {
        didSet { updateLabel() }
    }
    
    @IBInspectable public var glowAmount: CGFloat = 20 {
        didSet { updateLabel() }
    }
    
    @IBInspectable public var glowAlpha: CGFloat = 0.7 {
        didSet { updateLabel() }
    }
    
    // MARK: - override UILabel properties
    override public var text: String? {
        didSet { updateLabel() }
    }
    
    override public var attributedText: NSAttributedString? {
        didSet { updateLabel() }
    }
    
    override public var textColor: UIColor! {
        didSet { updateLabel() }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet { updateLabel()}
    }
    
    // MARK: - init functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        _customizing = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _customizing = false
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        updateLabel()
    }
    
    public override func drawText(in rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context!.saveGState()
        
        context!.setShadow(offset: self.glowOffset, blur: self.glowAmount)
        context!.setAlpha(self.glowAlpha)
        context!.setShadow(offset: CGSize.zero, blur: self.glowAmount, color: self.glowColor.cgColor)
        
        super.drawText(in: rect)
        
        context!.restoreGState();
        
    }
    
    // MARK: - customization
    public func customize(block: (_ label: GlowLabel) -> ()) -> GlowLabel{
        _customizing = true
        block(self)
        _customizing = false
        updateLabel()
        return self
    }
    
    private func updateLabel() {
        if _customizing { return }
        self.setNeedsDisplay()
    }
    
    // MARK: - private properties
    private var _customizing: Bool = true
    private var colorSpaceRef: CGColorSpace = CGColorSpaceCreateDeviceRGB()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        font = fontToFitHeight()
    }
    
    private func fontToFitHeight() -> UIFont {
        
        var minFontSize: CGFloat = 1 // CGFloat 18
        var maxFontSize: CGFloat = 25     // CGFloat 67
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard (text?.characters.count)! > 0 else {
                break
            }
            
            if let labelText: NSString = text as! NSString {
                
                let labelHeight = frame.size.width
                
                let testStringHeight = labelText.size(
                    attributes: [NSFontAttributeName: font.withSize(fontSizeAverage)]
                    ).width
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        return font.withSize(fontSizeAverage - 1)
                    }
                    return font.withSize(fontSizeAverage)
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                } else {
                    return font.withSize(fontSizeAverage)
                }
                
            }
            
        }
        
        return font.withSize(fontSizeAverage)
        
    }
    
}

@IBDesignable public class GlowLabelSimple: UILabel {
    
    // MARK: properties
    @IBInspectable public var glowColor: UIColor = .clear {
        didSet { updateLabel() }
    }
    
    @IBInspectable public var glowOffset: CGSize = CGSize(width: 0, height:0) {
        didSet { updateLabel() }
    }
    
    @IBInspectable public var glowAmount: CGFloat = 20 {
        didSet { updateLabel() }
    }
    
    @IBInspectable public var glowAlpha: CGFloat = 0.7 {
        didSet { updateLabel() }
    }
    
    // MARK: - override UILabel properties
    override public var text: String? {
        didSet { updateLabel() }
    }
    
    override public var attributedText: NSAttributedString? {
        didSet { updateLabel() }
    }
    
    override public var textColor: UIColor! {
        didSet { updateLabel() }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet { updateLabel()}
    }
    
    // MARK: - init functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        _customizing = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _customizing = false
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        updateLabel()
    }
    
    public override func drawText(in rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context!.saveGState()
        
        context!.setShadow(offset: self.glowOffset, blur: self.glowAmount)
        context!.setAlpha(self.glowAlpha)
        context!.setShadow(offset: CGSize.zero, blur: self.glowAmount, color: self.glowColor.cgColor)
        
        super.drawText(in: rect)
        
        context!.restoreGState();
        
    }
    
    // MARK: - customization
    public func customize(block: (_ label: GlowLabelSimple) -> ()) -> GlowLabelSimple {
        _customizing = true
        block(self)
        _customizing = false
        updateLabel()
        return self
    }
    
    private func updateLabel() {
        if _customizing { return }
        self.setNeedsDisplay()
    }
    
    // MARK: - private properties
    private var _customizing: Bool = true
    private var colorSpaceRef: CGColorSpace = CGColorSpaceCreateDeviceRGB()
    
}
