//
//  DataManager.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 25/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
 Esta clase se va a encargar de la gestion de todos los datos
 e informacion que se manejan en la aplicacion
 */
class DataMaganer {
    
    //La unica instancia de la clase lo que la
    //adhiere al patron de singleton
    static let sharedInstance: DataMaganer = {
        let instance = DataMaganer()
        instance.verificarInstalacion()
        return instance
    }()
    
    //Variable que guarda la informacion que se lee
    //del fichero json cuando se inicia la aplicacion
    var json: JSON? = nil
    
    /*
     Esta clase se encanrga de determinar si en directorio
     de Documentos en la instalacion de la aplicacion se 
     encuentra el fichero bitagora_data.json que va a contener 
     toda la informacion y si no es asi lo copia en la ubicacion
     */
    private func verificarInstalacion() {
        
        if !FileManager.fileExistsInDocumentsDirectory(relativePath: "bitagora_data.json") {
            
            do {
                if let file = Bundle.main.url(forResource: "bitagora_data", withExtension: "json") {
                    let data = try Data(contentsOf: file)
                    FileManager.writeToDocumentsDirectory(data: data, relativePath: "bitagora_data.json")
                    verificarInstalacion()
                } else {
                    print("No existe el fichero en el bundle: bitagora_data.json")
                }
            } catch {
                print(error.localizedDescription)
            }
            
        } else {
            
            if let data = FileManager.retrieveDataFromDocumentsDirectory(relativePath: "bitagora_data.json") {
                
                json = JSON(data: data)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss.sss"
                json?["last_update"].string = dateFormatter.string(from: Date()).uppercased()
                
                guardarEnDisco()
                
            }
            
        }
        
    }
    
    public func guardarJuego(titulo: String, coverImage: UIImage?, logoImage: UIImage?) -> Game {
        
        let tituloFinal = /*titulo.components(separatedBy: " ")[0] + "_" + */randomString(length: 10)
        var rutaCover = ""
        var rutaLogo = ""
        
        //Se crea un nuevo directorio para almacenar la informacion y
        //componentes de cada uno de los juegos gestionados en el sistema
        
        do {
            
            let directorioJuego = FileManager.documentsDirectoryURL().appendingPathComponent(tituloFinal)

            try FileManager.default.createDirectory(atPath: directorioJuego.path, withIntermediateDirectories: true, attributes: nil)
            
            if let cover = coverImage {
                if let data = UIImagePNGRepresentation(cover) {
                    if FileManager.writeToDocumentsDirectory(data: data, relativePath: tituloFinal + "/" + "cover.png") {
                        //rutaCover = FileManager.documentsDirectoryPathForResource(relativePath: tituloFinal + "/" + "cover.png")
                        rutaCover = "cover.png"
                    }
                }
            }
            
            if let logo = logoImage {
                if let data = UIImagePNGRepresentation(logo) {
                    if FileManager.writeToDocumentsDirectory(data: data, relativePath: tituloFinal + "/" + "logo.png") {
                        //rutaLogo = FileManager.documentsDirectoryPathForResource(relativePath: tituloFinal + "/" + "logo.png")
                        rutaLogo = "logo.png"
                    }
                }
            }
            
            //En este punto, si no ha habido errores se guarda la
            //informacion en el fichero JSON con los datos
            
            if (json?["juegos"].exists())! {

                let update: JSON = JSON(["juegos": [["id": tituloFinal, "titulo": titulo, "cover": rutaCover, "logo": rutaLogo]]])
                try json?.merge(with: update)

                guardarEnDisco()
                
            }
            
        } catch let error as NSError {
            print("Error: \(error.debugDescription)")
        }
        
        return Game(title: tituloFinal)
        
    }
    
    /*
     Este metodo guarda en disco los cambios efectuados en un JSON
     */
    private func guardarEnDisco() {
        
        do {
            let data_updated = try json?.rawData(options: .prettyPrinted)
            FileManager.writeToDocumentsDirectory(data: data_updated!, relativePath: "bitagora_data.json")
        } catch {
            print(error.localizedDescription)
        }
    
    }
    
    /*
     Funcion que devuelve una cadena aletoria para identificar
     principalmente a cada uno de los juegos que se registran
     */
    private func randomString(length: Int) -> String {
        
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = charSet.characters.map { String($0) }
        var s:String = ""
        for _ in (1...length) {
            s.append(c[Int(arc4random()) % c.count])
        }
        
        return s
        
    }
    
}
