//
//  GameTableViewCell.swift
//  ViewTest
//
//  Created by Lazaro Garcia Cruz on 2/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit
import Gifu

protocol GameTableViewCellDelegate: class {
    func borrarCelda(index: Int)
}

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var shadowMainView: GradientView!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundGifImage: GIFImageView!
    @IBOutlet weak var specularImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var imagenTapizBlanco: UIImageView!
    @IBOutlet weak var botonCancelarBorrado: UIButton!
    @IBOutlet weak var botonBorrar: RuneTextView!
    var isModoBorrado = false
    
    var indexPath: IndexPath?
    var delegate: GameTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /*
     En este metodo se inicializan los componentes visuales
     que se engloban dentro de la celda que representa
     */
    func prepararCelda() {
        
        mainView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        titleText.isHidden = true
        if backgroundImage.image == nil && backgroundGifImage == nil && logoImage.image == nil {
            titleText.isHidden = false
            titleText.textColor = .white
            titleText.shadowColor = .black
        } else if (backgroundImage.image != nil || backgroundGifImage != nil) && logoImage.image == nil {
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
                self.setRotation(x: offset, y: 0, z: offset)
            case .centro:
                self.setRotation(x: offset*2, y: 0, z: 0)
            case .derecha:
                self.setRotation(x: offset, y: 0, z: -offset)
            }
            
        })
        
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
