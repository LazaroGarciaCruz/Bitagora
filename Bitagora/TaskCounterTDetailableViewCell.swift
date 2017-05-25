//
//  TaskCounterTDetailableViewCell.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 23/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit

protocol TaskCounterDetailTableViewCellDelegate: class {
    func actualizarContador(actualElements: Int, index: Int)
}

class TaskCounterTDetailableViewCell: UITableViewCell {

    @IBOutlet weak var textoDescripcion: UILabel!
    @IBOutlet weak var textoContador: UILabel!
    
    var cantidadTotal = 0 {
        didSet {
            textoContador.text = "\(cantidadActual) / \(cantidadTotal)"
        }
    }
    var cantidadActual = 0 {
        didSet {
            textoContador.text = "\(cantidadActual) / \(cantidadTotal)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    var indexPath: IndexPath?
    
    var delegate: TaskCounterDetailTableViewCellDelegate?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func incrementarContador(_ sender: Any) {
        
        if cantidadActual + 1 <= cantidadTotal {
            cantidadActual += 1
            delegate?.actualizarContador(actualElements: cantidadActual, index: (indexPath?.row)!)
        }
        
    }
    
    @IBAction func decrementarContador(_ sender: Any) {
        
        if cantidadActual - 1 > -1 {
            cantidadActual -= 1
            delegate?.actualizarContador(actualElements: cantidadActual, index: (indexPath?.row)!)
        }
        
    }
    
}
