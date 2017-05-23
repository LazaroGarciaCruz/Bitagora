//
//  GameTableViewCell.swift
//  ViewTest
//
//  Created by Lazaro Garcia Cruz on 2/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var shadowMainView: GradientView!
    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var specularImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    
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

}
