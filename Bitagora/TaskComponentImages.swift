//
//  TaskComponentImages.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 18/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public class TaskComponentImages: TaskComponent {
    
    public var listaImagenes: Array<UIImage> = []
    public var listaNombresImagenes: Array<String> = []
    
    override init() {
        super.init(type: TaskComponentType.images)
    }
    
    init?(id: String, attributes: [String: Any]) {
        
        super.init(type: TaskComponentType.images)
        
        for imagen in ((attributes["imagenes"] as? JSON)?.arrayObject)! {
            if let imageAux = DataMaganer.sharedInstance.cargarImagenAlmacenada(directorio: id, imagen: imagen as! String) {
                listaImagenes.append(imageAux)
                listaNombresImagenes.append(imagen as! String)
            }
        }
        
    }
    
}
