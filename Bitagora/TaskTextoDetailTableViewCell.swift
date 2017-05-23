//
//  TaskTextoDetailTableViewCell.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 23/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit

class TaskTextoDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UILabel!
    
    var texto = "" {
        didSet {
            textView.text = texto
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
