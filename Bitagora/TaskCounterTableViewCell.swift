//
//  TaskCounterTableViewCell.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 18/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit

protocol TaskCounterTableViewCellDelegate: class {
    func actualizarContador(maxElements: Int, index: Int)
    func actualizarDescripcion(descripcion: String, index: Int)
    func borrarElemento(index: Int)
}

class TaskCounterTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textoDescripcion: UITextField!
    @IBOutlet weak var textoCantidad: UILabel!
    @IBOutlet weak var botonMas: UIButton!
    @IBOutlet weak var botonMenos: UIButton!
    @IBOutlet weak var backView2: UIView!
    @IBOutlet weak var backView: UIView!
    
    weak var delegate: TaskCounterTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    var maxElements = 0 {
        didSet {
            textoCantidad.text = String(maxElements)
        }
    }
    
    var descripcion = "" {
        didSet {
            textoDescripcion.text = descripcion
        }
    }

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        textoDescripcion.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        let panel = UIView(frame: self.frame)
        panel.w = panel.w * 2
        panel.h = panel.h * 2
        panel.x = panel.x + 10
        panel.y = panel.y + 20
        panel.backgroundColor = .black
        
        self.addSubview(panel)
        self.sendSubview(toBack: panel)
        
        self.backgroundColor = .clear
        
        backView.addBorder(width: 2, color: .white)
        backView2.addBorder(width: 2, color: .white)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func inicializarComponentes() {
        
    }
    
    func textDidChange(_ textViewChanged: UITextView) {
        delegate?.actualizarDescripcion(descripcion: textoDescripcion.text!, index: (indexPath?.row)!)
    }
    
    @IBAction func aumentarContador(_ sender: Any) {

        maxElements = maxElements + (maxElements + 1 > 100 ? 0 : 1)
        textoCantidad.text = String(maxElements)
        delegate?.actualizarContador(maxElements: maxElements, index: (indexPath?.row)!)
        
    }

    @IBAction func decrementarContador(_ sender: Any) {
        
        maxElements = maxElements - (maxElements - 1 < 0 ? 0 : 1)
        textoCantidad.text = String(maxElements)
        delegate?.actualizarContador(maxElements: maxElements, index: (indexPath?.row)!)
        
    }
    
    @IBAction func borrarCelda(_ sender: Any) {
        delegate?.borrarElemento(index: (indexPath?.row)!)
    }
    
    /*
     Con este metodo se limitan el numero de caracteres
     maximos permitidos para el texto de la descripcion
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 50
        let currentString: NSString = textoDescripcion.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
        
    }
    
}
