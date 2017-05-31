//
//  GameTaskTableViewCell.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 10/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit
import Gifu

protocol GameTaskTableViewCellDelegate: class {
    func borrarCelda(index: Int)
}

class GameTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var fondo: UIView!
    @IBOutlet weak var pantalla: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewTexto: UIView!
    @IBOutlet weak var textoTitulo: GlowLabelSimple!
    @IBOutlet weak var textoFecha: GlowLabelSimple!
    @IBOutlet weak var viewIconos: UIView!
    @IBOutlet weak var viewEstados: UIView!
    @IBOutlet weak var imagenPrioridad: GIFImageView!
    @IBOutlet weak var imagenDificultad: GIFImageView!
    
    @IBOutlet weak var imagenHardware: GIFImageView!
    
    @IBOutlet weak var viewTextoLeading: NSLayoutConstraint!
    @IBOutlet weak var viewTextoTop: NSLayoutConstraint!
    
    @IBOutlet weak var botonBorrar: GlowLabelSimple!
    @IBOutlet weak var botonCancelarBorrado: UIButton!
    var isModoBorrado = false
    
    var indexPath: IndexPath?
    var delegate: GameTaskTableViewCellDelegate?
    
    var cadenaTitulo = ""
    var cadenaFecha = ""
    
    var isIphone = false
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            isIphone = false
        } else {
            isIphone = true
        }
        
        textoTitulo.text = ""
        textoFecha.text = ""
        mainView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        pantalla.isHidden = true
        imagenHardware.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /*
     Este metodo se llama cada vez que la
     celda va a ser reutilizar e inicializa
     los elementos visuales de la misma
     */
    override func prepareForReuse() {
        
        textoTitulo.text = ""
        textoFecha.text = ""
        mainView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        pantalla.isHidden = true
        
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
     En este metodo se ejecuta la animacion que
     se muestra la primera vez que aparece la celda
     */
    func animacionCeldaEncenderMonitor() {
        
        if isIphone {
            viewTextoTop.constant = 5
            viewTextoLeading.constant = 8
        } else {
            viewTextoTop.constant = -5
            viewTextoLeading.constant = 10
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(250)) {
            self.pantalla.isHidden = false
            self.pantalla.transform = CGAffineTransform(scaleX: 0.1, y: 0.01)
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.pantalla.transform = CGAffineTransform(scaleX: 1, y: 0.01)
            }, completion: {(exito) in
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.pantalla.transform = CGAffineTransform.identity
                }, completion: {(exito) in
                    self.animarTextos()
                })
            })
        }
        
    }
    
    /*
     En este metodo se ejecuta la animacion que
     se muestra cuando desaparece
     */
    func animacionCeldaApagarMonitor() {
        
        if isIphone {
            viewTextoTop.constant = 5
            viewTextoLeading.constant = 5
        } else {
            viewTextoTop.constant = -5
            viewTextoLeading.constant = 10
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(250)) {
            self.pantalla.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.pantalla.transform = CGAffineTransform(scaleX: 1, y: 0.01)
            }, completion: {(exito) in
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.pantalla.transform = CGAffineTransform(scaleX: 0, y: 0.01)
                }, completion: {(exito) in
                    self.pantalla.isHidden = true
                })
            })
        }
        
    }
    
    /*
     En este metodo se ejecuta la animacion
     de los textos que aparecen en la celda
     */
    func animarTextos() {
        
        textoTitulo.text = cadenaTitulo
        textoTitulo.animateText(timeInterval: 0.05)

        let when = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.textoFecha.text = self.cadenaFecha
            self.textoFecha.animateText(timeInterval: 0.05)
        }
        
    }
    
    /*
     Este metodo lleva a cabo las tareas necesarias para animar
     el posible borrado de la celda en cuestion
     */
    func animacionBorrado() {
        
        UIView.transition(with: self.contentView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.viewTexto.isHidden = true
            self.viewEstados.isHidden = true
            self.botonCancelarBorrado.isHidden = false
            self.botonBorrar.isHidden = false
            self.botonBorrar.animateText(timeInterval: 0.15)
        })
        
    }
    
    /*
     Este metodo lleva a cabo las tareas necesarias para animar
     la celda cuando se cancela el borrado de la misma
     */
    func cancelarBorrado() {
        
        UIView.transition(with: self.contentView, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.botonCancelarBorrado.isHidden = true
            self.botonBorrar.isHidden = true
            self.viewTexto.isHidden = false
            self.viewEstados.isHidden = false
        })
        
    }
    
}
