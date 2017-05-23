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
    
    weak var delegate: TaskTextoTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    var texto = "" {
        didSet {
            textView.text = texto
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        textView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)

        textView.addBorder(width: 1, color: .black)
        
        let panel = UIView(frame: self.frame)
        panel.w = panel.w * 2
        panel.h = panel.h * 100
        panel.x = panel.x + 10
        panel.y = panel.y + 20
        panel.backgroundColor = .black
        panel.tag = 100
        
        self.addSubview(panel)
        self.sendSubview(toBack: panel)
        
        self.backgroundColor = .clear
        
    }
    
    func inicializarComponentes() {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.establecerTextoActivo(index: (indexPath?.row)!)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.ajustarTexto()
    }
    
    func textDidChange(_ textViewChanged: UITextView) {
        delegate?.actualizarTexto(texto: textView.text, index: (indexPath?.row)!)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //delegate?.actualizarTexto(texto: textView.text, index: (indexPath?.row)!)
    }
    
    @IBAction func borrarCelda(_ sender: Any) {
        delegate?.borrarElemento(index: (indexPath?.row)!)
    }
    
}
