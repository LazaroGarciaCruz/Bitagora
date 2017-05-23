//
//  ExtensionsUIView.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 16/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
import ObjectiveC

// MARK: - UIView

let UIViewAnimationDuration: TimeInterval = 1
let UIViewAnimationSpringDamping: CGFloat = 0.5
let UIViewAnimationSpringVelocity: CGFloat = 0.5

extension UIView {
    
    // MARK: Custom Initilizer
    
    convenience init (x: CGFloat,
                      y: CGFloat,
                      w: CGFloat,
                      h: CGFloat) {
        self.init (frame: CGRect (x: x, y: y, width: w, height: h))
    }
    
    convenience init (superView: UIView) {
        self.init (frame: CGRect (origin: CGPoint.zero, size: superView.size))
    }
    
    func constraint(withIdentifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter { $0.identifier == withIdentifier }.first
    }
    
}

// MARK:- UIView extension -

extension UIView {
    
    func hasSuperview(_ superview: UIView) -> Bool{
        return viewHasSuperview(self, superview: superview)
    }
    
    fileprivate func viewHasSuperview(_ view: UIView, superview: UIView) -> Bool {
        
        if let sview = view.superview {
            if sview === superview {
                return true
            } else {
                return viewHasSuperview(sview, superview: superview)
            }
        } else{
            return false
        }
        
    }
    
}

// MARK: Frame Extensions

extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set (value) {
            self.frame = CGRect (x: value, y: self.y, width: self.w, height: self.h)
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set (value) {
            self.frame = CGRect (x: self.x, y: value, width: self.w, height: self.h)
        }
    }
    
    var w: CGFloat {
        get {
            return self.frame.size.width
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: value, height: self.h)
        }
    }
    
    var h: CGFloat {
        get {
            return self.frame.size.height
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: self.w, height: value)
        }
    }
    
    var left: CGFloat {
        get {
            return self.x
        } set (value) {
            self.x = value
        }
    }
    
    var right: CGFloat {
        get {
            return self.x + self.w
        } set (value) {
            self.x = value - self.w
        }
    }
    
    var top: CGFloat {
        get {
            return self.y
        } set (value) {
            self.y = value
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.y + self.h
        } set (value) {
            self.y = value - self.h
        }
    }
    
    var position: CGPoint {
        get {
            return self.frame.origin
        } set (value) {
            self.frame = CGRect (origin: value, size: self.frame.size)
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set (value) {
            self.frame = CGRect (origin: self.frame.origin, size: value)
        }
    }
    
    func leftWithOffset (offset: CGFloat) -> CGFloat {
        return self.left - offset
    }
    
    func rightWithOffset (offset: CGFloat) -> CGFloat {
        return self.right + offset
    }
    
    func topWithOffset (offset: CGFloat) -> CGFloat {
        return self.top - offset
    }
    
    func bottomWithOffset (offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }
    
}

// MARK: Transform Extensions

extension UIView {
    
    func setRotationX (x: CGFloat) {
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(angle: x), 1.0, 0.0, 0.0)
        
        self.layer.transform = transform
        
    }
    
    func setRotationY (y: CGFloat) {
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(angle: y), 0.0, 1.0, 0.0)
        
        self.layer.transform = transform
        
    }
    
    func setRotationZ (z: CGFloat) {
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(angle: z), 0.0, 0.0, 1.0)
        
        self.layer.transform = transform
        
    }
    
    func setRotation (
        
        x: CGFloat,
        y: CGFloat,
        z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, degreesToRadians(angle: x), 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, degreesToRadians(angle: y), 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, degreesToRadians(angle: z), 0.0, 0.0, 1.0)
        
        self.layer.transform = transform
        
    }
    
    func setScale (
        
        x: CGFloat,
        y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.layer.transform = transform
        
    }
    
}

// MARK: Layer Extensions

extension UIView {
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
}

extension UIView {
    
    public enum UIViewLinearGradientDirection : Int {
        
        case vertical
        case horizontal
        case diagonalFromLeftToRightAndTopToDown
        case diagonalFromLeftToRightAndDownToTop
        case diagonalFromRightToLeftAndTopToDown
        case diagonalFromRightToLeftAndDownToTop
        
    }
    
    public func createGradientWithColors(colors: Array<CGColor>, direction: UIViewLinearGradientDirection) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        
        switch direction {
            
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .diagonalFromLeftToRightAndTopToDown:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            
        case .diagonalFromLeftToRightAndDownToTop:
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
            
        case .diagonalFromRightToLeftAndTopToDown:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
            
        case .diagonalFromRightToLeftAndDownToTop:
            gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        }
        
        self.layer.insertSublayer(gradient, at:0)
        
    }
    
    func setCornerRadius (radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func addShadow (offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
        
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.cgColor
        
        if let r = cornerRadius {
            self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
        }
        
    }
    
    func setAnchorPosition (anchorPosition: AnchorPosition) {
        print(anchorPosition.rawValue)
        self.layer.anchorPoint = anchorPosition.rawValue
    }
    
    func addBorder (
        
        width: CGFloat,
        color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = true
        
    }
    
    func drawCircle (
        
        fillColor: UIColor,
        strokeColor: UIColor,
        strokeWidth: CGFloat) {
        let path = UIBezierPath (roundedRect: CGRect (x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)
        
        let shapeLayer = CAShapeLayer ()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    func drawStroke (
        
        width: CGFloat,
        color: UIColor) {
        let path = UIBezierPath (roundedRect: CGRect (x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)
        
        let shapeLayer = CAShapeLayer ()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    func drawArc (
        
        from: CGFloat,
        to: CGFloat,
        clockwise: Bool,
        width: CGFloat,
        fillColor: UIColor,
        strokeColor: UIColor,
        lineCap: String) {
        let path = UIBezierPath (arcCenter: self.center, radius: self.w/2, startAngle: degreesToRadians(angle: from), endAngle: degreesToRadians(angle: to), clockwise: clockwise)
        
        let shapeLayer = CAShapeLayer ()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = width
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
}


// MARK: Animation Extensions

extension UIView {
    
    func spring (
        animations: @escaping (()->Void),
        completion: ((Bool)->Void)? = nil) {
        spring(duration: UIViewAnimationDuration,
               animations: animations,
               completion: completion)
    }
    
    func spring (
        duration: TimeInterval,
        animations: @escaping (()->Void),
        completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: UIViewAnimationDuration,
                       delay: 0,
                       usingSpringWithDamping: UIViewAnimationSpringDamping,
                       initialSpringVelocity: UIViewAnimationSpringVelocity,
                       options: UIViewAnimationOptions.allowAnimatedContent,
                       animations: animations,
                       completion: completion)
    }
    
    func animate (
        duration: TimeInterval,
        animations: @escaping (()->Void),
        completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: duration,
                       animations: animations,
                       completion: completion)
    }
    
    func animate (
        animations: @escaping (()->Void),
        completion: ((Bool)->Void)? = nil) {
        animate(
            duration: UIViewAnimationDuration,
            animations: animations,
            completion: completion)
    }
    
    func pop () {
        setScale(x: 1.1, y: 1.1)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
        })
    }
    
}


// MARK: Render Extensions

extension UIView {
    
    func toImage () -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
        
    }
    
}


// MARK: Gesture Extensions

extension UIView {
    
    func addTapGesture (
        
        tapNumber: Int,
        target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer (target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        
    }
    
    func addTapGesture (
        
        tapNumber: Int,
        action: ((UITapGestureRecognizer)->())?) {
        let tap = BlockTap (tapCount: tapNumber,
                            fingerCount: 1,
                            action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        
    }
    
    func addSwipeGesture (
        
        direction: UISwipeGestureRecognizerDirection,
        numberOfTouches: Int,
        target: AnyObject,
        action: Selector) {
        let swipe = UISwipeGestureRecognizer (target: target, action: action)
        swipe.direction = direction
        swipe.numberOfTouchesRequired = numberOfTouches
        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
        
    }
    
    func addSwipeGesture (
        
        direction: UISwipeGestureRecognizerDirection,
        numberOfTouches: Int,
        action: ((UISwipeGestureRecognizer)->())?) {
        let swipe = BlockSwipe (direction: direction,
                                fingerCount: numberOfTouches,
                                action: action)
        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
        
    }
    
    func addPanGesture (
        
        target: AnyObject,
        action: Selector) {
        let pan = UIPanGestureRecognizer (target: target, action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
        
    }
    
    func addPanGesture (action: ((UIPanGestureRecognizer)->())?) {
        
        let pan = BlockPan (action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
        
    }
    
    func addPinchGesture (
        
        target: AnyObject,
        action: Selector) {
        let pinch = UIPinchGestureRecognizer (target: target, action: action)
        addGestureRecognizer(pinch)
        isUserInteractionEnabled = true
        
    }
    
    func addPinchGesture (action: ((UIPinchGestureRecognizer)->())?) {
        
        let pinch = BlockPinch (action: action)
        addGestureRecognizer(pinch)
        isUserInteractionEnabled = true
        
    }
    
    func addLongPressGesture (
        
        target: AnyObject,
        action: Selector) {
        let longPress = UILongPressGestureRecognizer (target: target, action: action)
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
        
    }
    
    func addLongPressGesture (action: ((UILongPressGestureRecognizer)->())?) {
        
        let longPress = BlockLongPress (action: action)
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
        
    }
    
}

extension UIView {
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
}


