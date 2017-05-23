//
//  RuneTextView.swift
//  ViewTest
//
//  Created by Lazaro Garcia Cruz on 8/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit

class RuneTextView: UIView {
    
    var texto: String = ""
    var animacionRapida = false
    
    func animarTexto() {
        
        self.backgroundColor = .clear
        
        let width = self.frame.width / CGFloat(texto.characters.count)
        
        for numLabel in 0 ... texto.characters.count-1 {
            
            let label = GlowLabel(frame: CGRect(x: (CGFloat(numLabel) * width), y: 0, width: width, height: self.frame.height))
            label.text = texto[Int(numLabel)]
            label.textAlignment = .center
            label.font = UIFont(name: "PixelRunes", size: 10)
            label.textColor = .red
            label.numberOfLines = 0
            label.backgroundColor = .clear
            label.alpha = 0
            
            label.glowColor = .red
            label.glowOffset = CGSize(width: 10, height: 10)
            label.glowAmount = 5
            label.glowAlpha = 1
            
            //label.addBorder(width: 3, color: .yellow)
            
            self.addSubview(label)
            
        }
        
        var index = 0
        var animacionesFinalizadas = 0
        
        let tiempoAnimacionRapida = 0.05
        let delayAnimacionRapida = 0.01
        let tiempoAnimacionLenta = 0.35
        let delayAnimacionLenta = 0.15
        
        for i in self.subviews {
            
            let label: GlowLabel = i as! GlowLabel
            
            UIView.animate(withDuration: animacionRapida ? tiempoAnimacionRapida : tiempoAnimacionLenta, delay: (animacionRapida ? delayAnimacionRapida : delayAnimacionLenta) * Double(index), animations: {
                label.alpha = 1
            }, completion: {(exito) in
                UIView.transition(with: label, duration: self.animacionRapida ? tiempoAnimacionRapida : tiempoAnimacionLenta, options: .transitionCrossDissolve, animations: { () -> Void in
                    label.textColor = .orange
                    label.glowColor = .orange
                }) {(finish) in
                    UIView.transition(with: label, duration: self.animacionRapida ? tiempoAnimacionRapida : tiempoAnimacionLenta, options: .transitionCrossDissolve, animations: { () -> Void in
                        label.textColor = .yellow
                        label.glowColor = .yellow
                    }) {(finish) in
                        UIView.transition(with: label, duration: self.animacionRapida ? tiempoAnimacionRapida : tiempoAnimacionLenta, options: .transitionCrossDissolve, animations: { () -> Void in
                            label.textColor = .white
                            label.glowColor = .white
                        }) {(finish) in
                            UIView.transition(with: label, duration: self.animacionRapida ? tiempoAnimacionRapida : tiempoAnimacionLenta, options: .transitionCrossDissolve, animations: { () -> Void in
                                label.textColor = .black
                                label.glowColor = .clear
                            }) {(finish) in
                            
                                animacionesFinalizadas += 1
                                
                                if animacionesFinalizadas == self.subviews.count {
                                    
                                    var index = 0
                                    
                                    for i in self.subviews {
                                        
                                        let label: GlowLabel = i as! GlowLabel
                                        
                                        UIView.animate(withDuration: self.animacionRapida ? tiempoAnimacionRapida : tiempoAnimacionLenta, delay: (self.animacionRapida ? delayAnimacionRapida : delayAnimacionLenta) * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
                                            label.setRotationY(y: 90)
                                        }, completion: {(exito) in
                                            label.font = UIFont(name: "Pixel-Art", size: 10)
                                            label.textColor = .white
                                            label.shadowColor = UIColor.black
                                            label.shadowOffset = CGSize(width: 1, height: 1)
                                            //label.glowColor = .white
                                            //label.textColor = UIColor(red: 252/255, green: 2/255, blue: 84/255, alpha: 1)
                                            //label.shadowColor = UIColor(red: 144/255, green: 42/255, blue: 135/255, alpha: 1)
                                            //label.shadowOffset = CGSize(width: 3, height: 3)
                                            UIView.animate(withDuration: self.animacionRapida ? tiempoAnimacionRapida : tiempoAnimacionLenta, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
                                                label.setRotationY(y: 0)
                                            }, completion: nil)
                                        })
                                        
                                        index += 1
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                }
                
            })
            
            index += 1
            
        }
        
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*override func draw(_ rect: CGRect) {
    }*/

}
