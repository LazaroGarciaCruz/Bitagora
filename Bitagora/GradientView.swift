//
//  GradientView.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 16/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    
    var colores: Array<CGColor>? {
        didSet {
            (self.layer as! CAGradientLayer).colors = colores
        }
    }
    
    var direccion: UIViewLinearGradientDirection? {
        didSet {
            let gradient: CAGradientLayer = self.layer as! CAGradientLayer
            if let direccion = self.direccion {
                switch direccion {
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
            }
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
}
