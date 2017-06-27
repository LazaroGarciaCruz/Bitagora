//
//  Game.swift
//  ViewTest
//
//  Created by Lazaro Garcia Cruz on 27/4/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

/*
 Esta clase va a representar cada uno de los juegos que gestiona la aplicacion
 */

import Foundation
import UIKit
import SwiftyJSON

public class Game {
    
    var id: String = ""
    var title: String = ""
    var logoImage: UIImage?
    var coverImage: UIImage?
    var coverGifData: Data?
    var isCoverGif = false
    var taskLista: Array<GameTask> = []
    
    init() {}
    
    init?(attributes: [String: Any]) {
        
        guard let id = (attributes["id"] as? JSON)?.string,
            let titulo = (attributes["titulo"] as? JSON)?.string,
            let cover = (attributes["cover"] as? JSON)?.string,
            let logo = (attributes["logo"] as? JSON)?.string
            else {
                return nil
        }
        
        self.id = id
        self.title = titulo
        
        if cover.contains(".gif") {
            isCoverGif = true
            if let dataAux = DataMaganer.sharedInstance.cargarDataGifAlmacenado(directorio: id, imagen: cover) {
                coverGifData = dataAux
            }
        } else {
            isCoverGif = false
            if let imageAux = DataMaganer.sharedInstance.cargarImagenAlmacenada(directorio: id, imagen: cover) {
                coverImage = imageAux
            }
        }
        
        if let imageAux = DataMaganer.sharedInstance.cargarImagenAlmacenada(directorio: id, imagen: logo) {
            logoImage = imageAux
        }
        
    }
    
}
