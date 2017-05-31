//
//  TaskTextoTableViewCell.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 12/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit

protocol TaskTextoTableViewCellDelegate: class {
    func ajustarTexto()
    func actualizarTexto(texto: String, index: Int)
    func establecerTextoActivo(index: Int)
    func borrarElemento(index: Int)
}

class TaskTextoTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textTip: UILabel!
    
    weak var delegate: TaskTextoTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    var texto = "" {
        didSet {
            textView.text = texto
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        textView.delegate = self
        //textView.addBorder(width: 1, color: UIColor(red: 128/255, green: 0/255, blue: 64/255, alpha: 1))
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
    }
    
    func inicializarComponentes() {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.establecerTextoActivo(index: (indexPath?.row)!)
        textTip.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.ajustarTexto()
    }
    
    func textDidChange(_ textViewChanged: UITextView) {
        delegate?.actualizarTexto(texto: textView.text, index: (indexPath?.row)!)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //delegate?.actualizarTexto(texto: textView.text, index: (indexPath?.row)!)
        if textView.text == "" {
            textTip.isHidden = false
        }
    }
    
    @IBAction func borrarCelda(_ sender: Any) {
        delegate?.borrarElemento(index: (indexPath?.row)!)
    }
    
}
