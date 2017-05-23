//
//  ScrollingBackgroundView.swift
//  ViewTest
//
//  Created by Lazaro Garcia Cruz on 5/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit

class ScrollingBackgroundView: UIView {
    
    @IBInspectable var backgroundImage: UIImage? {
        didSet {
            backgroundOne = UIImageView(image: self.backgroundImage)
            backgroundTwo = UIImageView(image: self.backgroundImage)
        }
    }
    
    var scaleMode: UIViewContentMode = .scaleAspectFill {
        didSet {
            backgroundOne?.contentMode = scaleMode
            backgroundTwo?.contentMode = scaleMode
        }
    }
    
    @IBInspectable var duracion: Double = 10.0 {
        didSet {
            duracionAnimacion = duracion
        }
    }
    
    var isVertical = false
    
    //var scaleMode: UIViewContentMode = .scaleAspectFill
    var duracionAnimacion: Double = 10
    var backgroundOne: UIImageView?
    var backgroundTwo: UIImageView?
    
    func animarBackground() {
        
        backgroundOne?.clipsToBounds = true
        backgroundOne?.contentMode = scaleMode
        backgroundOne?.frame = CGRect(x: 0, y: 0, width: w * 2, height: h)
        addSubview(backgroundOne!)
        
        backgroundTwo?.clipsToBounds = true
        backgroundTwo?.contentMode = scaleMode
        backgroundTwo?.frame = CGRect(x: (backgroundOne?.w)!, y: 0, width: w * 2, height: h)
        addSubview(backgroundTwo!)
        
        sendSubview(toBack: backgroundOne!)
        sendSubview(toBack: backgroundTwo!)
        
        if isVertical {
            UIView.animate(withDuration: duracionAnimacion, delay: 0, options: [.repeat, .curveLinear], animations: {
                
                self.backgroundOne?.transform = CGAffineTransform(translationX: 0, y: -(self.backgroundOne?.h)!)
                self.backgroundTwo?.transform = CGAffineTransform(translationX: 0, y: -(self.backgroundOne?.h)!)
                
            }, completion: nil)
        } else {
            UIView.animate(withDuration: duracionAnimacion, delay: 0, options: [.repeat, .curveLinear], animations: {
                
                self.backgroundOne?.transform = CGAffineTransform(translationX: -(self.backgroundOne?.w)!, y: 0)
                self.backgroundTwo?.transform = CGAffineTransform(translationX: -(self.backgroundOne?.w)!, y: 0)
                
            }, completion: nil)
        }
        
    }
    
    func pauseBackground() {
        
        backgroundOne?.layer.removeAllAnimations()
        backgroundOne?.transform = CGAffineTransform.identity
        backgroundTwo?.layer.removeAllAnimations()
        backgroundTwo?.transform = CGAffineTransform.identity
        
    }
    
    func resumeBackground() {
        
        UIView.animate(withDuration: duracionAnimacion, delay: 0, options: [.repeat, .curveLinear], animations: {
            
            self.backgroundOne?.transform = CGAffineTransform(translationX: -(self.backgroundOne?.w)!, y: 0)
            self.backgroundTwo?.transform = CGAffineTransform(translationX: -(self.backgroundOne?.w)!, y: 0)
            
        }, completion: nil)
        
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

}
