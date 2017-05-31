//
//  ExtensionBible.swift
//  ExtensionBible-Swift
//
//  Created by Lazaro Garcia Cruz on 25/4/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
import ObjectiveC

// MARK: - AppDelegate

// let APPDELEGATE: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate

// MARK: - UITextField

extension UITextField{
    
    @IBInspectable var placeHolderColor: UIColor? {
        
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
        
    }
    
}

// MARK: - UIBarItem extension -

extension UIBarItem {
    var view: UIView? {
        if let item = self as? UIBarButtonItem, let customView = item.customView {
            return customView
        }
        return self.value(forKey: "view") as? UIView
    }
}

// MARK: - UIScrollView

extension UIScrollView {

    var contentHeight: CGFloat {
        get {
            return contentSize.height
        } set (value) {
            contentSize = CGSize (width: contentSize.width, height: value)
        }
    }

    var contentWidth: CGFloat {
        get {
            return contentSize.height
        } set (value) {
            contentSize = CGSize (width: value, height: contentSize.height)
        }
    }

    var offsetX: CGFloat {
        get {
            return contentOffset.x
        } set (value) {
            contentOffset = CGPoint (x: value, y: contentOffset.y)
        }
    }

    var offsetY: CGFloat {
        get {
            return contentOffset.y
        } set (value) {
            contentOffset = CGPoint (x: contentOffset.x, y: value)
        }
    }
    
}

// MARK: - UIViewController

extension UIViewController {

    var top: CGFloat {
        
        get {

            if let me = self as? UINavigationController {
                return me.visibleViewController!.top
            }

            if let nav = self.navigationController {
                if nav.isNavigationBarHidden {
                    return view.top
                } else {
                    return nav.navigationBar.bottom
                }
            } else {
                return view.top
            }
        }
        
    }

    var bottom: CGFloat {
        
        get {

            if let me = self as? UINavigationController {
                return me.visibleViewController!.bottom
            }

            if let tab = tabBarController {
                if tab.tabBar.isHidden {
                    return view.bottom
                } else {
                    return tab.tabBar.top
                }
            } else {
                return view.bottom
            }
        }
        
    }


    var tabBarHeight: CGFloat {
        
        get {

            if let me = self as? UINavigationController {
                return me.visibleViewController!.tabBarHeight
            }

            if let tab = self.tabBarController {
                return tab.tabBar.frame.size.height
            }

            return 0
        }
        
    }

    var navigationBarHeight: CGFloat {
        
        get {

            if let me = self as? UINavigationController {
                return me.visibleViewController!.navigationBarHeight
            }

            if let nav = self.navigationController {
                return nav.navigationBar.h
            }

            return 0
        }
        
    }

    var navigationBarColor: UIColor? {
        
        get {

            if let me = self as? UINavigationController {
                return me.visibleViewController!.navigationBarColor
            }

            return navigationController?.navigationBar.tintColor
        } set (value) {
            navigationController?.navigationBar.barTintColor = value
        }
        
    }

    var navBar: UINavigationBar? {
        get {
            return navigationController?.navigationBar
        }
    }


    var applicationFrame: CGRect {
        get {
            return CGRect (x: view.x, y: top, width: view.w, height: bottom - top)
        }
    }

    func push (vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }

    func pop () {
        navigationController?.popViewController(animated: true)
    }

    func present (vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }

    func dismiss (completion: (()->Void)?) {
        dismiss(animated: true, completion: completion)
    }
    
}

// MARK: - TableView

extension UITableView {
    
    public enum UITableViewAnimationDirection : Int {
        case up
        case down
        case left
        case right
    }
    
    func reloadWithAnimation(tableView: UITableView, animationDirection: UITableViewAnimationDirection) {
        
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
        let cells = tableView.visibleCells
        var index = 0
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            
            let cell: UITableViewCell = i as UITableViewCell
            
            switch animationDirection {
            case .up:
                cell.transform = CGAffineTransform(translationX: 0, y: -tableHeight)
                break
            case .down:
                cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
                break
            case .left:
                cell.transform = CGAffineTransform(translationX: tableHeight, y: 0)
                break
            case .right:
                cell.transform = CGAffineTransform(translationX: -tableHeight, y: 0)
                break
            default:
                cell.transform = CGAffineTransform(translationX: tableHeight, y: 0)
                break
            }
            
            UIView.animate(withDuration: 1, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            
            index += 1
            
        }
        
    }
    
}

// MARK: - CollectionView

extension UICollectionView {
    
    public enum UICollectionViewAnimationDirection : Int {
        case up
        case down
        case left
        case right
    }
    
    func reloadWithAnimation(collectionView: UICollectionView, animationDirection: UICollectionViewAnimationDirection) {
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        let cells = collectionView.visibleCells
        var index = 0
        let tableHeight: CGFloat = collectionView.bounds.size.height
        
        for i in cells {
            
            let cell: UICollectionViewCell = i as UICollectionViewCell
            
            switch animationDirection {
            case .up:
                cell.transform = CGAffineTransform(translationX: 0, y: -tableHeight)
                break
            case .down:
                cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
                break
            case .left:
                cell.transform = CGAffineTransform(translationX: tableHeight, y: 0)
                break
            case .right:
                cell.transform = CGAffineTransform(translationX: -tableHeight, y: 0)
                break
            default:
                cell.transform = CGAffineTransform(translationX: tableHeight, y: 0)
                break
            }
            
            UIView.animate(withDuration: 1, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            
            index += 1
            
        }
        
    }
    
}

import ObjectiveC
// MARK: - UILabel

private var UILabelAttributedStringArray: UInt8 = 0

extension UILabel {
    
    func animateText(timeInterval: Double) {
        
        //timeInterval -> max: 1, recomendado: 0.05
        
        var textoActual = self.text
        self.text = ""
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            
            var textoAux = ""
            for char in (textoActual?.characters)! {
                
                textoAux.append(char)
                DispatchQueue.main.async {
                    self.text = textoAux + String("_")
                }
                
                Thread.sleep(forTimeInterval: TimeInterval(timeInterval))
                
            }
            
            DispatchQueue.main.async {
                self.text = textoAux
            }
            
        }
        
    }
    
}

extension UILabel {

    var attributedStrings: [NSAttributedString]? {
        
        get {
            return objc_getAssociatedObject(self, &UILabelAttributedStringArray) as? [NSAttributedString]
        }
        set {
            objc_setAssociatedObject(self, &UILabelAttributedStringArray, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }


    func addAttributedString (
        
        text: String,
        color: UIColor,
        font: UIFont) {
            let att = NSAttributedString (text: text, color: color, font: font)
            self.addAttributedString(attributedString: att)
        
    }

    func addAttributedString (attributedString: NSAttributedString) {
        
        var att: NSMutableAttributedString?

        if let a = self.attributedText {
            att = NSMutableAttributedString (attributedString: a)
            att?.append(attributedString)
        } else {
            att = NSMutableAttributedString (attributedString: attributedString)
            attributedStrings = []
        }

        attributedStrings?.append(attributedString)
        self.attributedText = NSAttributedString (attributedString: att!)
        
    }

    func updateAttributedStringAtIndex (index: Int, attributedString: NSAttributedString) {

        if let _ = attributedStrings?[index] {
            attributedStrings?.remove(at: index)
            attributedStrings?.insert(attributedString, at: index)

            let updated = NSMutableAttributedString ()
            for att in attributedStrings! {
                updated.append(att)
            }

            self.attributedText = NSAttributedString (attributedString: updated)
        }
        
    }

    func updateAttributedStringAtIndex (index: Int, newText: String) {
        
        if let att = attributedStrings?[index] {
            
            let newAtt = NSMutableAttributedString (string: newText)

            att.enumerateAttributes(in: NSMakeRange(0, att.string.characters.count-1),
                                    options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired,
                                    using: { (attribute, range, stop) -> Void in
                    for (key, value) in attribute {
                        newAtt.addAttribute(key , value: value, range: range)
                    }
                }
            )

            updateAttributedStringAtIndex(index: index, attributedString: newAtt)
            
        }
        
    }

    func getEstimatedSize (
        width: CGFloat = CGFloat.greatestFiniteMagnitude,
        height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
            return sizeThatFits(CGSize(width: width, height: height))
    }

    func getEstimatedHeight () -> CGFloat {
        return sizeThatFits(CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)).height
    }

    func getEstimatedWidth () -> CGFloat {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: h)).width
    }

    func fitHeight () {
        self.h = getEstimatedHeight()
    }

    func fitWidth () {
        self.w = getEstimatedWidth()
    }

    func fitSize () {
        self.fitWidth()
        self.fitHeight()
        sizeToFit()
    }

    // Text, TextColor, TextAlignment, Font

    convenience init (
        frame: CGRect,
        text: String,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont) {
            self.init(frame: frame)
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font

            self.numberOfLines = 0
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat,
        text: String,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont) {
        self.init(frame: CGRect (x: x, y: y, width: width, height: height))
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font
            self.numberOfLines = 0
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        text: String,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont) {
        self.init(frame: CGRect (x: x, y: y, width: width, height: 10.0))
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font
            self.numberOfLines = 0
            self.fitHeight()
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        padding: CGFloat,
        text: String,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont) {
            self.init(frame: CGRect (x: x, y: y, width: width, height: 10.0))
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font
            self.numberOfLines = 0
            self.h = self.getEstimatedHeight() + 2*padding
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        text: String,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont) {
            self.init(frame: CGRect (x: x, y: y, width: 10.0, height: 10.0))
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.font = font
            self.numberOfLines = 0
            self.fitSize()
    }

    // AttributedText

    convenience init (
        frame: CGRect,
        attributedText: NSAttributedString,
        textAlignment: NSTextAlignment) {
            self.init(frame: frame)
            self.attributedText = attributedText
            self.textAlignment = textAlignment
            self.numberOfLines = 0
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat,
        attributedText: NSAttributedString,
        textAlignment: NSTextAlignment) {
            self.init(frame: CGRect (x: x, y: y, width: width, height: height))
            self.attributedText = attributedText
            self.textAlignment = textAlignment
            self.numberOfLines = 0
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        attributedText: NSAttributedString,
        textAlignment: NSTextAlignment) {
            self.init(frame: CGRect (x: x, y: y, width: width, height: 10.0))
            self.attributedText = attributedText
            self.textAlignment = textAlignment
            self.numberOfLines = 0
            self.fitHeight()
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        padding: CGFloat,
        attributedText: NSAttributedString,
        textAlignment: NSTextAlignment) {
            self.init(frame: CGRect (x: x, y: y, width: width, height: 10.0))
            self.attributedText = attributedText
            self.textAlignment = textAlignment
            self.numberOfLines = 0
            self.fitHeight()
            self.h += padding*2
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        attributedText: NSAttributedString,
        textAlignment: NSTextAlignment) {
            self.init(frame: CGRect (x: x, y: y, width: 10.0, height: 10.0))
            self.attributedText = attributedText
            self.textAlignment = textAlignment
            self.numberOfLines = 0
            self.fitSize()
    }

}

// MARK: NSAttributedString

extension NSAttributedString {

    enum NSAttributedStringStyle {
        
        case plain
        case underline (NSUnderlineStyle, UIColor)
        case strike (UIColor, CGFloat)

        func attribute () -> [NSString: NSObject] {
            
            switch self {
                
                case .plain:
                    return [:]

                case .underline(let styleName, let color):
                    return [NSUnderlineStyleAttributeName as NSString: styleName.rawValue as NSObject, NSUnderlineColorAttributeName as NSString: color]

                case .strike(let color, let width):
                    return [NSStrikethroughColorAttributeName as NSString: color, NSStrikethroughStyleAttributeName as NSString: width as NSObject]
                
            }
            
        }
        
    }

    func addAtt (attribute: [NSString: NSObject]) -> NSAttributedString {
        
        let mutable = NSMutableAttributedString (attributedString: self)
        let c = string.characters.count

        for (key, value) in attribute {
            mutable.addAttribute(key as String, value: value, range: NSMakeRange(0, c))
        }

        return mutable
        
    }

    func addStyle (style: NSAttributedStringStyle) -> NSAttributedString {
        return addAtt(attribute: style.attribute())
    }

    convenience init (
        
        text: String,
        color: UIColor,
        font: UIFont,
        style: NSAttributedStringStyle = .plain) {
            var atts: [String: AnyObject] = [NSFontAttributeName as String: font, NSForegroundColorAttributeName as String: color]
            for (key, value) in style.attribute() {
                atts.updateValue(value, forKey:key as String)
            }

            self.init (string: text, attributes: atts)
        
    }

    convenience init (image: UIImage) {
        let att = NSTextAttachment ()
        att.image = image
        self.init (attachment: att)
    }


    class func withAttributedStrings (mutableString: (NSMutableAttributedString)->()) -> NSAttributedString {
        let mutable = NSMutableAttributedString ()
        mutableString (mutable)
        return mutable
    }
    
}

// MARK: - String

extension String {
    subscript (i: Int) -> String {
        return String(Array(self.characters)[i])
    }
}

// MARK: - UIFont

enum FontType: String {
    case Regular = "Regular"
    case Bold = "Bold"
    case DemiBold = "DemiBold"
    case Light = "Light"
    case UltraLight = "UltraLight"
    case Italic = "Italic"
    case Thin = "Thin"
    case Book = "Book"
    case Roman = "Roman"
    case Medium = "Medium"
    case MediumItalic = "MediumItalic"
    case CondensedMedium = "CondensedMedium"
    case CondensedExtraBold = "CondensedExtraBold"
    case SemiBold = "SemiBold"
    case BoldItalic = "BoldItalic"
    case Heavy = "Heavy"
}

enum FontName: String {
    case HelveticaNeue = "HelveticaNeue"
    case Helvetica = "Helvetica"
    case Futura = "Futura"
    case Menlo = "Menlo"
    case Avenir = "Avenir"
    case AvenirNext = "AvenirNext"
    case Didot = "Didot"
    case AmericanTypewriter = "AmericanTypewriter"
    case Baskerville = "Baskerville"
    case Geneva = "Geneva"
    case GillSans = "GillSans"
    case SanFranciscoDisplay = "SanFranciscoDisplay"
    case Seravek = "Seravek"
    case PixelRunes = "PixelRunes.ttf"
}

extension UIFont {

    class func PrintFontFamily (font: FontName) {
        let arr = UIFont.fontNames(forFamilyName: font.rawValue)
        for name in arr {
            print(name)
        }
    }

    class func Font (
        name: FontName,
        type: FontType,
        size: CGFloat) -> UIFont {
            return UIFont (name: name.rawValue + "-" + type.rawValue, size: size)!
    }

    class func HelveticaNeue (
        type: FontType,
        size: CGFloat) -> UIFont {
            return Font(name: .HelveticaNeue, type: type, size: size)
    }

    class func AvenirNext (
        type: FontType,
        size: CGFloat) -> UIFont {
            return UIFont.Font(name: .AvenirNext, type: type, size: size)
    }

    class func AvenirNextDemiBold (size: CGFloat) -> UIFont {
        return AvenirNext(type: .DemiBold, size: size)
    }

    class func AvenirNextRegular (size: CGFloat) -> UIFont {
        return AvenirNext(type: .Regular, size: size)
    }
    
}

// MARK: - UIImageView

extension UIImageView {

    convenience init (
        frame: CGRect,
        imageName: String) {
            self.init (frame: frame, image: UIImage (named: imageName)!)
    }

    convenience init (
        frame: CGRect,
        image: UIImage) {
            self.init (frame: frame)
            self.image = image
            self.contentMode = .scaleAspectFit
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        image: UIImage) {
        self.init (frame: CGRect (x: x, y: y, width: width, height: image.aspectHeightForWidth(width: width)), image: image)
    }

    convenience init (
        x: CGFloat,
        y: CGFloat,
        height: CGFloat,
        image: UIImage) {
        self.init (frame: CGRect (x: x, y: y, width: image.aspectWidthForHeight(height: height), height: height), image: image)
    }

    func imageWithUrl (url: String) {
        imageRequest(url: url, success: { (image) -> Void in
            if let _ = image {
                self.image = image
            }
        })
    }

    func imageWithUrl (url: String, placeholder: UIImage) {
        self.image = placeholder
        imageRequest(url: url, success: { (image) -> Void in
            if let _ = image {
                self.image = image
            }
        })
    }

    func imageWithUrl (url: String, placeholderNamed: String) {
        self.image = UIImage (named: placeholderNamed)
        imageRequest(url: url, success: { (image) -> Void in
            if let _ = image {
                self.image = image
            }
        })
    }
    
}

// MARK: - UIImage

extension UIImage {

    func aspectResizeWithWidth (width: CGFloat) -> UIImage {
        
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width: width))

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
        
    }

    func aspectResizeWithHeight (height: CGFloat) -> UIImage {
        
        let aspectSize = CGSize (width: aspectWidthForHeight(height: height), height: height)

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
        
    }

    func aspectHeightForWidth (width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }

    func aspectWidthForHeight (height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
    
}

extension UIImage {
    
    func resizableImageWithStretchingProperties(
        
        X: CGFloat, width widthProportion: CGFloat,
        Y: CGFloat, height heightProportion: CGFloat) -> UIImage {
        
        let selfWidth = self.size.width
        let selfHeight = self.size.height
        
        // insets along width
        let leftCapInset = X*selfWidth*(1-widthProportion)
        let rightCapInset = (1-X)*selfWidth*(1-widthProportion)
        
        // insets along height
        let topCapInset = Y*selfHeight*(1-heightProportion)
        let bottomCapInset = (1-Y)*selfHeight*(1-heightProportion)
        
        return self.resizableImage(
            withCapInsets: UIEdgeInsets(top: topCapInset, left: leftCapInset,
                         bottom: bottomCapInset, right: rightCapInset),
            resizingMode: .stretch)
        
    }
    
}

// MARK: - UIColor

extension UIColor {

    class func randomColor () -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())

        return UIColor(red: randomRed,
            green: randomGreen,
            blue: randomBlue,
            alpha: 1.0)
    }

    class func RGBColor (
        r: CGFloat,
        g: CGFloat,
        b: CGFloat) -> UIColor {
            return UIColor (red: r / 255.0,
                green: g / 255.0,
                blue: b / 255.0,
                alpha: 1)
    }

    class func RGBAColor (
        r: CGFloat,
        g: CGFloat,
        b: CGFloat,
        a: CGFloat) -> UIColor {
            return UIColor (red: r / 255.0,
                green: g / 255.0,
                blue: b / 255.0,
                alpha: a)
    }

    class func BarTintRGBColor (
        r: CGFloat,
        g: CGFloat,
        b: CGFloat) -> UIColor {
            return UIColor (red: (r / 255.0) - 0.12,
                green: (g / 255.0) - 0.12,
                blue: (b / 255.0) - 0.12,
                alpha: 1)
    }

    class func Gray (gray: CGFloat) -> UIColor {
        return self.RGBColor(r: gray, g: gray, b: gray)
    }

    class func Gray (gray: CGFloat, alpha: CGFloat) -> UIColor {
        return self.RGBAColor(r: gray, g: gray, b: gray, a: alpha)
    }
    
}



// MARK - UIScreen

extension UIScreen {

    class var Orientation: UIInterfaceOrientation {
        get {
            return UIApplication.shared.statusBarOrientation
        }
    }

    class var ScreenWidth: CGFloat {
        get {
            if UIInterfaceOrientationIsPortrait(Orientation) {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
    }

    class var ScreenHeight: CGFloat {
        get {
            if UIInterfaceOrientationIsPortrait(Orientation) {
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
    }

    class var StatusBarHeight: CGFloat {
        get {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
}

// MARK: - Array

extension Array {
    
    mutating func removeObject<U: Equatable> (object: U) {
        var index: Int?
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }

        if(index != nil) {
            self.remove(at: index!)
        }
    }
    
}

// MARK: - CGSize

func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSize (width: left.width + right.width, height: left.height + right.height)
}

func - (left: CGSize, right: CGSize) -> CGSize {
    return CGSize (width: left.width - right.width, height: left.width - right.width)
}

// MARK: - CGPoint

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint (x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint (x: left.x - right.x, y: left.y - right.y)
}

enum AnchorPosition: CGPoint {
    case TopLeft        = "{0, 0}"
    case TopCenter      = "{0.5, 0}"
    case TopRight       = "{1, 0}"

    case MidLeft        = "{0, 0.5}"
    case MidCenter      = "{0.5, 0.5}"
    case MidRight       = "{1, 0.5}"

    case BottomLeft     = "{0, 1}"
    case BottomCenter   = "{0.5, 1}"
    case BottomRight    = "{1, 1}"
}

extension CGPoint: ExpressibleByStringLiteral {

    public init(stringLiteral value: StringLiteralType) {
        self = CGPointFromString(value)
    }

    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self = CGPointFromString(value)
    }

    public init(unicodeScalarLiteral value: StringLiteralType) {
        self = CGPointFromString(value)
    }
    
}

extension CGRect {
    
    var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.origin.y
        }
        
        set {
            self.origin.y = newValue
        }
    }
    
    
    //    var width: CGFloat {
    //        get {
    //         return self.size.width
    //        }
    //
    //        set {
    //            self.size.width = newValue
    //        }
    //    }
    //
    //    var height: CGFloat {
    //        get {
    //            return self.size.height
    //        }
    //
    //        set{
    //            self.size.height = newValue
    //        }
    //    }
    
    //    var maxX: CGFloat {
    //        return self.maxX
    //    }
    //
    //    var maxY: CGFloat {
    //        return self.maxY
    //    }
    
    var center: CGPoint {
        return CGPoint(x: self.x + self.width / 2, y: self.y + self.height / 2)
    }
    
}

// MARK: - CGFloat

func degreesToRadians (angle: CGFloat) -> CGFloat {
    return (CGFloat (M_PI) * angle) / 180.0
}

func normalizeValue (
    value: CGFloat,
    min: CGFloat,
    max: CGFloat) -> CGFloat {
        return (max - min) / value
}

func convertNormalizedValue (
    normalizedValue: CGFloat,
    min: CGFloat,
    max: CGFloat) -> CGFloat {
        return ((max - min) * normalizedValue) + min
}

func clamp (
    value: CGFloat,
    minimum: CGFloat,
    maximum: CGFloat) -> CGFloat {
        return min (maximum, max(value, minimum))
}

func aspectHeightForTargetAspectWidth (
    currentHeight: CGFloat,
    currentWidth: CGFloat,
    targetAspectWidth: CGFloat) -> CGFloat {
        return (targetAspectWidth * currentHeight) / currentWidth
}

func aspectWidthForTargetAspectHeight (
    currentHeight: CGFloat,
    currentWidth: CGFloat,
    targetAspectHeight: CGFloat) -> CGFloat {
        return (targetAspectHeight * currentWidth) / currentHeight
}

// MARK: - Dictionary

func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>,
    right: Dictionary<KeyType, ValueType>) {
        for (k, v) in right {
            left.updateValue(v, forKey: k)
        }
}

// MARK: - Dispatch

/*func delay (
    seconds: Double,
    queue: dispatch_queue_t = dispatch_get_main_queue(),
    after: ()->()) {

        let time = dispatch_time(dispatch_time_t(DispatchTime.now()), Int64(seconds * Double(NSEC_PER_SEC)))
        dispatch_after(time, queue, after)
}*/

// MARK: - DownloadTask

func urlRequest (url: String, success: @escaping (NSData?)->Void, error: ((NSError)->Void)? = nil) {
    
    NSURLConnection.sendAsynchronousRequest(
        NSURLRequest (url: NSURL (string: url)! as URL) as URLRequest,
        queue: OperationQueue.main,
        completionHandler: { response, data, err in
            if let e = err {
                error? (e as NSError)
            } else {
                success (data as NSData?)
            }
    })
    
}

func imageRequest (url: String, success: @escaping (UIImage?)->Void) {
    
    urlRequest(url: url, success: { (data) -> Void in
        if let d = data {
            success (UIImage (data: d as Data))
        }
    })
    
}

func jsonRequest (url: String, success: @escaping ((AnyObject?)->Void), error: ((NSError)->Void)?) {
    
    urlRequest(
        url: url,
        success: { (data)->Void in
            let json: AnyObject? = dataToJsonDict(data: data) as AnyObject?
            success (json)
        },
        error: { (err)->Void in
            if let e = error {
                e (err)
            }
    })
    
}

func dataToJsonDict (data: NSData?) -> Any? {

    if let d = data {
        
        var error: NSError?
        let json: Any?
        do {
            json = try JSONSerialization.jsonObject(
                with: d as Data,
                options: JSONSerialization.ReadingOptions.allowFragments)
        } catch let error1 as NSError {
            error = error1
            json = nil
        }

        if let _ = error {
            return nil
        } else {
            return json
        }
        
    } else {
        return nil
    }
    
}

// MARK: - UIAlertController

@available(iOS 8.0, *)
func alert (title: String, message: String, cancelAction: ((UIAlertAction?)->Void)? = nil, okAction: ((UIAlertAction?)->Void)? = nil) -> UIAlertController {
    
    let a = UIAlertController (title: title, message: message, preferredStyle: .alert)

    if let ok = okAction {
        a.addAction(UIAlertAction(title: "OK", style: .default, handler: ok))
        a.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction))
    } else {
        a.addAction(UIAlertAction(title: "OK", style: .cancel, handler: cancelAction))
    }

    return a

}

@available(iOS 8.0, *)
func actionSheet (title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
    
    let a = UIAlertController (title: title, message: message, preferredStyle: .actionSheet)

    for action in actions {
        a.addAction(action)
    }

    return a
    
}



// MARK: - UIBarButtonItem

func barButtonItem (imageName: String, size: CGFloat, action: @escaping (AnyObject)->()) -> UIBarButtonItem {
    
    let button = BlockButton (frame: CGRect(x: 0, y: 0, width: size, height: size))
    button.setImage(UIImage(named: imageName), for: .normal)
    button.actionBlock = action

    return UIBarButtonItem (customView: button)
    
}

func barButtonItem (imageName: String, action: @escaping (AnyObject)->()) -> UIBarButtonItem {
    return barButtonItem(imageName: imageName, size: 20, action: action)
}

func barButtonItem (title: String, color: UIColor, action: @escaping (AnyObject)->()) -> UIBarButtonItem {
    
    let button = BlockButton (frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    button.setTitle(title, for: .normal)
    button.setTitleColor(color, for: .normal)
    button.actionBlock = action
    button.sizeToFit()

    return UIBarButtonItem (customView: button)
    
}



// MARK: - BlockButton

public class BlockButton: UIButton {

    // init (x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
    //     super.init (frame: CGRect (x, y, w, h))
    // }
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var actionBlock: ((_ sender: BlockButton) -> ())? {
        didSet {
            self.addTarget(self, action: Selector(("action:")), for: UIControlEvents.touchUpInside)
        }
    }

    func action (sender: BlockButton) {
        actionBlock! (sender)
    }
    
}

// MARK: - BlockWebView

public class BlockWebView: UIWebView, UIWebViewDelegate {

    var didStartLoad: ((NSURLRequest) -> ())?
    var didFinishLoad: ((NSURLRequest) -> ())?
    var didFailLoad: ((NSURLRequest, NSError) -> ())?

    var shouldStartLoadingRequest: ((NSURLRequest) -> (Bool))?

    // override init!(frame: CGRect) {
    //     super.init(frame: frame)
    //     delegate = self
    // }
    //
    // required init?(coder aDecoder: NSCoder) {
    //     super.init(coder: aDecoder)
    // }

    public func webViewDidStartLoad(_ webView: UIWebView) {
        didStartLoad? (webView.request! as NSURLRequest)
    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        didFinishLoad? (webView.request! as NSURLRequest)
    }

    public func webView(
        _ webView: UIWebView,
        didFailLoadWithError error: Error) {
            didFailLoad? (webView.request! as NSURLRequest, error as NSError)
    }

    public func webView(
        _ webView: UIWebView,
        shouldStartLoadWith request: URLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            if let should = shouldStartLoadingRequest {
                return should (request as NSURLRequest)
            } else {
                return true
            }
    }

}

// MARK: BlockTap

public class BlockTap: UITapGestureRecognizer {

    private var tapAction: ((UITapGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init (
        tapCount: Int,
        fingerCount: Int,
        action: ((UITapGestureRecognizer) -> Void)?) {
            self.init()
            self.numberOfTapsRequired = tapCount
            self.numberOfTouchesRequired = fingerCount
            self.tapAction = action
        self.addTarget(self, action: #selector((didTap)))
    }

    func didTap (tap: UITapGestureRecognizer!) {
        tapAction? (tap)
    }

}


// MARK: BlockPan

public class BlockPan: UIPanGestureRecognizer {

    private var panAction: ((UIPanGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init (action: ((UIPanGestureRecognizer) -> Void)?) {
        self.init()
        self.panAction = action
        self.addTarget(self, action: #selector((didPan)))
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func didPan (pan: UIPanGestureRecognizer) {
        panAction? (pan)
    }
    
}

// MARK: BlockSwipe

public class BlockSwipe: UISwipeGestureRecognizer {

    private var swipeAction: ((UISwipeGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init (direction: UISwipeGestureRecognizerDirection,
        fingerCount: Int,
        action: ((UISwipeGestureRecognizer) -> Void)?) {
            self.init()
            self.direction = direction
            numberOfTouchesRequired = fingerCount
            swipeAction = action
        addTarget(self, action: #selector((didSwipe)))
    }

    func didSwipe (swipe: UISwipeGestureRecognizer) {
        swipeAction? (swipe)
    }
    
}

// MARK: BlockPinch

public class BlockPinch: UIPinchGestureRecognizer {

    private var pinchAction: ((UIPinchGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init (action: ((UIPinchGestureRecognizer) -> Void)?) {
        self.init()
        pinchAction = action
        addTarget(self, action: #selector((didPinch)))
    }

    func didPinch (pinch: UIPinchGestureRecognizer) {
        pinchAction? (pinch)
    }
    
}

// MARK: BlockLongPress

public class BlockLongPress: UILongPressGestureRecognizer {

    private var longPressAction: ((UILongPressGestureRecognizer) -> Void)?

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    convenience init (action: ((UILongPressGestureRecognizer) -> Void)?) {
        self.init()
        longPressAction = action
        addTarget(self, action: #selector((didLongPressed)))
    }

    func didLongPressed (longPress: UILongPressGestureRecognizer) {
        longPressAction? (longPress)
    }
    
}
