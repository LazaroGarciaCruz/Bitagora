//
//  GameCollectionViewCell.swift
//  ViewTest
//
//  Created by Lazaro Garcia Cruz on 26/4/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit

protocol GameCollectionViewCellDelegate: class {
    func borrarCelda(index: Int)
}

class GameCollectionViewCell: UICollectionViewCell {
    
    let colores: Array<CGColor> = [UIColor(red: 144/255, green: 42/255, blue: 135/255, alpha: 1).cgColor,
                                   UIColor(red: 252/255, green: 2/255, blue: 84/255, alpha: 1).cgColor]
    
    let colores2: Array<CGColor> = [UIColor(red: 2/255, green: 73/255, blue: 93/255, alpha: 1).cgColor,
                                    UIColor(red: 186/255, green: 217/255, blue: 2/255, alpha: 1).cgColor]
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var shadowMainView: GradientView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var specularImage: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var imagenTapizBlanco: UIImageView!
    
    @IBOutlet weak var botonCancelarBorrado: UIButton!
    @IBOutlet weak var botonBorrar: RuneTextView!
    var isModoBorrado = false
    
    var indexPath: IndexPath?
    var delegate: GameCollectionViewCellDelegate?
    
    /*
     En este metodo se inicializan los componentes visuales
     que se engloban dentro de la celda que representa
     */
    func prepararCelda() {
        
        shadowMainView.setCornerRadius(radius: 5)
        backgroundImage.setCornerRadius(radius: 5)
        logoImage.setCornerRadius(radius: 5)
        specularImage.setCornerRadius(radius: 5)
        
        titleText.isHidden = true
        if backgroundImage.image == nil && logoImage.image == nil {
            titleText.isHidden = false
            titleText.textColor = .black
            titleText.shadowColor = .clear
        } else if backgroundImage.image != nil && logoImage.image == nil {
            titleText.isHidden = false
            titleText.textColor = .white
            titleText.shadowColor = .black
        }
        
        if botonCancelarBorrado.gestureRecognizers == nil {
            botonCancelarBorrado.addTapGesture(tapNumber: 1, action: { (sender) in
                self.cancelarBorrado()
            })
        }
        
        if botonBorrar.gestureRecognizers == nil {
            botonBorrar.addTapGesture(tapNumber: 1, action: { (sender) in
                self.delegate?.borrarCelda(index: (self.indexPath?.row)!)
            })
        }
        
    }
    
    /*
     Este metodo lleva a cabo la animacion de arrastre sobre
     la celda en funcion de la posicion vertical y de en que
     parte de la pantalla ha pulsado el usuario
     */
    func animacionScroll(offset: CGFloat, posicion: ScreenTouchPosition) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            
            switch posicion {
            case .izquierda:
                self.setRotation(x: offset/2, y: 0, z: offset/2)
            case .centro:
                self.setRotation(x: offset*2, y: 0, z: 0)
            case .derecha:
                self.setRotation(x: offset/2, y: 0, z: -offset/2)
            }
            
        }, completion: nil)
        
    }
    
    /*
     Este metodo lleva a cabo las tareas necesarias para animar
     el posible borrado de la celda en cuestion
     */
    func animacionBorrado() {
        
        UIView.transition(with: self.contentView, duration: 0.5, options: .transitionFlipFromLeft, animations: { 
            self.mainContentView.isHidden = true
            self.imagenTapizBlanco.isHidden = true
            self.botonCancelarBorrado.isHidden = false
            self.botonBorrar.isHidden = false
            self.botonBorrar.borrarTexto()
            self.botonBorrar.texto = "BORRAR"
            self.botonBorrar.animacionRapida = true
            self.botonBorrar.animarTexto()
        }) { (sucess) in
            
        }
        
    }
    
    /*
     Este metodo lleva a cabo las tareas necesarias para animar
     la celda cuando se cancela el borrado de la misma
     */
    func cancelarBorrado() {
        
        UIView.transition(with: self.contentView, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.botonCancelarBorrado.isHidden = true
            self.botonBorrar.isHidden = true
            self.mainContentView.isHidden = false
            self.imagenTapizBlanco.isHidden = false
        }) { (sucess) in
            
        }
        
    }
    
}
