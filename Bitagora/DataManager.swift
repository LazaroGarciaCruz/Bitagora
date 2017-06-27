//
//  DataManager.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 25/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation
import SwiftyJSON
import ImageSlideshow

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
    
    //-----------------------------------------------------------------
    //---------- FUNCIONES SOBRE LA CARGA DE LA APLICACION ------------
    //-----------------------------------------------------------------
    
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
    
    /*
     Este metodo devuelve la informacion guardada en el fichero JSON
     estructurada en la lista de juegos, tareas y subtareas que se
     utilizan en el uso de la aplicacion
     */
    public func cargarListaDatos() -> Array<Game> {
        
        var listaDatos: Array<Game> = []
        
        //Procesamos el JSON para sacar la lista general de juegos y sus propiedades
        if (json?["juegos"].exists())! {
            
            for (_, value):(String, JSON) in (json?["juegos"])! {
                let game = Game(attributes: value.dictionary!)!
                listaDatos.append(game)
            }
            
        }
        
        if (json?["tasks"].exists())! {
            
            for (_, value):(String, JSON) in (json?["tasks"])! {
                let task = GameTask(attributes: value.dictionary!)!
                for juego in listaDatos {
                    if juego.id == task.idJuego {
                        juego.taskLista.append(task)
                    }
                }
            }
            
        }
        
        return listaDatos
        
    }
    
    //-----------------------------------------------------------------
    //---------------- FUNCIONES SOBRE LOS JUEGOS ---------------------
    //-----------------------------------------------------------------
    
    /*
     Este metodo lleva a cabo las tareas necesarias para almacenar 
     un nuevo juego en el sistema de archivos del JSON
     */
    public func guardarJuego(titulo: String, coverImage: UIImage?, logoImage: UIImage?, isCoverGif: Bool, gifData: Data?) -> Game {
        
        let tituloFinal = randomString(length: 10).uppercased()
        var rutaCover = ""
        var rutaLogo = ""
        
        //Se crea un nuevo directorio para almacenar la informacion y
        //componentes de cada uno de los juegos gestionados en el sistema
        
        do {
            
            let directorioJuego = FileManager.documentsDirectoryURL().appendingPathComponent(tituloFinal)

            try FileManager.default.createDirectory(atPath: directorioJuego.path, withIntermediateDirectories: true, attributes: nil)
            
            if !isCoverGif {
            
                if let cover = coverImage {
                    if let data = UIImagePNGRepresentation(cover) {
                        if FileManager.writeToDocumentsDirectory(data: data, relativePath: tituloFinal + "/" + "cover.png") {
                            //rutaCover = FileManager.documentsDirectoryPathForResource(relativePath: tituloFinal + "/" + "cover.png")
                            rutaCover = "cover.png"
                        }
                    }
                }
                
            } else {
                
                if FileManager.writeToDocumentsDirectory(data: gifData!, relativePath: tituloFinal + "/" + "cover.gif") {
                    //rutaCover = FileManager.documentsDirectoryPathForResource(relativePath: tituloFinal + "/" + "cover.png")
                    rutaCover = "cover.gif"
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

                let newData: JSON = (["id": tituloFinal, "titulo": titulo, "cover": rutaCover, "logo": rutaLogo])
                let update: JSON = JSON(["juegos": [newData]])
                try json?.merge(with: update)

                guardarEnDisco()
                
                return Game(attributes: newData.dictionary!)!
                
            }
            
        } catch let error as NSError {
            print("Error: \(error.debugDescription)")
        }
        
        return Game()
        
    }
    
    /*
     Este metodo lleva a cabo las tareas necesarias para borrar un
     juego de la lista de juegos almacenada en un JSON asi como
     sus tareas asociadas y las subtareas
     */
    func borrarJuego(juego: Game) -> Bool {
        
        if (json?["tasks"].exists())! {
            for task in juego.taskLista {
                borrarTask(task: task)
            }
        }
        
        if FileManager.deleteDataFromDocumentsDirectory(relativePath: juego.id) {
    
            if (json?["juegos"].exists())! {
                for (key, value):(String, JSON) in (json?["juegos"])! {
                    if value["id"].string == juego.id {
                        json?["juegos"].arrayObject?.remove(at: Int(key)!)
                    }
                }
            }
            
            guardarEnDisco()
            
            return true
            
        }
        
        return false
        
    }
    
    //-----------------------------------------------------------------
    //----------------- FUNCIONES SOBRE LOS TASK ----------------------
    //-----------------------------------------------------------------
    
    /*
     Este metodo realiza las tareas necesarias para guar en disco la
     informacion de una nueva tarea y actualizar el JSON
     */
    func almacenarTask(idJuego: String, titulo: String, dificultad: TaskDifficulty, prioridad: TaskPriority, listaComponentes: Array<TaskComponent>) -> GameTask {
        
        //Almacenamos en disco los elementos de los
        //componentes del task y generamos el fragmento
        //de JSON que los representa
        
        if (json?["tasks"].exists())! {
            
            do {
            
                var listaComponentesJSON: Array<JSON> = []
                
                for componente in listaComponentes {
                    switch componente.type {
                    case .text:
                        listaComponentesJSON.append(convertirToJSON(componente: componente as! TaskComponentText))
                    case .images:
                        listaComponentesJSON.append(convertirToJSON(id: idJuego, componente: componente as! TaskComponentImages))
                    case .url:
                        listaComponentesJSON.append(convertirToJSON(componente: componente as! TaskComponentURL))
                    case .counter:
                        listaComponentesJSON.append(convertirToJSON(componente: componente as! TaskComponentCounter))
                    default:
                        listaComponentesJSON.append(JSON(""))
                    }
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss.sss"
                let id = randomString(length: 10).uppercased()
                
                let newData: JSON = (["id": id, "idJuego": idJuego, "titulo": titulo, "fecha": dateFormatter.string(from: Date()),
                                      "dificultad": dificultad.rawValue, "prioridad": prioridad.rawValue, "componentes": listaComponentesJSON])
                let update: JSON = JSON(["tasks": [newData]])
                try json?.merge(with: update)
                
                guardarEnDisco()
                
                //return GameTask(attributes: newData.dictionary!, listaComponentes: listaComponentes)!
                return GameTask(attributes: newData.dictionary!)!
                
            } catch let error as NSError {
                print("Error: \(error.debugDescription)")
            }
            
        }
        
        return GameTask()
        
    }
    
    /*
     Este metodo lleva a cabo las tareas necesarias para borrar un
     task de la lista de task de un juego almacenada en un JSON
    */
    func borrarTask(task: GameTask) -> Bool {
        
        //Se comprueba si el task tiene algun
        //componente de imagen y si es asi se
        //borrar las imagenes asociadas
        for componente in task.listaComponentesTask {
            if componente.type == TaskComponentType.images {
                let componenteImage = componente as! TaskComponentImages
                for imagen in componenteImage.listaNombresImagenes {
                    if !FileManager.deleteDataFromDocumentsDirectory(relativePath: task.idJuego + "/" + imagen + ".png") {
                       print("Error borrando imagen \(imagen) del task \(task.id)")
                    }
                }
            }
        }
        
        //Con el siguiente codigo se borra la 
        //informacion del task del JSON
        
        if (json?["tasks"].exists())! {
            
            for (key, value):(String, JSON) in (json?["tasks"])! {
                if value["id"].string == task.id {
                    var listaTask = json?["tasks"].arrayObject
                    listaTask?.remove(at: Int(key)!)
                    json?.dictionaryObject?.updateValue(listaTask, forKey: "tasks")
                }
            }
            
            guardarEnDisco()
            
            return true
            
        }
        
        return false
        
    }
    
    /*
     Este metodo lleva a cabo las tareas necesarias para actualizar
     el valor de contado de un task determinado
     */
    func actualizarContadorTask(id: String, taskComponente: TaskComponentCounter) {
        
        if (json?["tasks"].exists())! {
            
            var taskNumber = 0
            var taskNumberCurrent = 0
            var taskNumberComponente = 0
            var taskNumberComponenteCurrent = 0
            
            for (_, value):(String, JSON) in (json?["tasks"])! {
                if value["id"].string == id {
                    taskNumberComponenteCurrent = 0
                    for componente in value["componentes"] {
                        if TaskComponentType(rawValue: componente.1.dictionaryObject?["tipo"] as! Int)! == TaskComponentType.counter
                            && componente.1.dictionaryObject?["id"] as! String == taskComponente.id {
                            taskNumberComponente = taskNumberComponenteCurrent
                        } else {
                            taskNumberComponenteCurrent += 1
                        }
                    }
                    taskNumber = taskNumberCurrent
                } else {
                    taskNumberCurrent += 1
                }
            }
            
            json?["tasks"][taskNumber]["componentes"][taskNumberComponente].dictionaryObject?.updateValue(taskComponente.currentElementCount, forKey: "elementosActuales")
            
            guardarEnDisco()
            
        }
        
    }
    
    /*
     Devuelve las propiedades de un componente de tarea
     de texto en formato JSON
     */
    func convertirToJSON(componente: TaskComponentText) -> JSON {
        return JSON(["tipo": componente.type.rawValue, "texto": componente.texto])
    }
    
    /*
     Devuelve las propiedades de un componente de tarea
     de imagenes en formato JSON
     */
    func convertirToJSON(id: String, componente: TaskComponentImages) -> JSON {
        
        var listaImagenes: Array<String> = []
        for imagen in componente.listaImagenes {
            let tituloImagen = randomString(length: 10).uppercased()
            if let data = UIImagePNGRepresentation(imagen) {
                if FileManager.writeToDocumentsDirectory(data: data, relativePath: id + "/" + tituloImagen + ".png") {
                    listaImagenes.append(tituloImagen)
                    componente.listaNombresImagenes.append(tituloImagen)
                }
            }
        }
        
        return JSON(["tipo": componente.type.rawValue, "imagenes": listaImagenes])
 
    }
    
    /*
     Devuelve las propiedades de un componente de tarea
     de enalce en formato JSON
     */
    func convertirToJSON(componente: TaskComponentURL) -> JSON {
        return JSON(["tipo": componente.type.rawValue, "isVideo": componente.isVideo, "URL": componente.url])
    }
    
    /*
     Devuelve las propiedades de un componente de tarea
     de contador en formato JSON
     */
    func convertirToJSON(componente: TaskComponentCounter) -> JSON {
        return JSON(["tipo": componente.type.rawValue, "id": componente.id, "descripcion": componente.descripcion, "maxElementos": componente.maxElements, "elementosActuales": componente.currentElementCount])
    }
    
    //-----------------------------------------------------------------
    //-------------------- FUNCIONES GENERALES ------------------------
    //-----------------------------------------------------------------
    
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
     Este metodo devuelve una imagen almacenada en disco si existe
     */
    func cargarImagenAlmacenada(directorio: String, imagen: String) -> UIImage? {
        
        let rutaImagen = FileManager.documentsDirectoryURL().appendingPathComponent(directorio).appendingPathComponent(imagen)
        return UIImage(contentsOfFile: rutaImagen.path)
        
    }
    
    /*
     Este metodo devuelve el data de un gif almacenado en disco
     */
    func cargarDataGifAlmacenado(directorio: String, imagen: String) -> Data? {
        
        let rutaImagen = FileManager.documentsDirectoryURL().appendingPathComponent(directorio).appendingPathComponent(imagen)
        
        if let data = try? Data(contentsOf: rutaImagen) { return data }
        
        return nil
        
    }
    
    /*
     Funcion que devuelve una cadena aletoria para identificar
     principalmente a cada uno de los juegos que se registran
     */
    public func randomString(length: Int) -> String {
        
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = charSet.characters.map { String($0) }
        var s:String = ""
        for _ in (1...length) {
            s.append(c[Int(arc4random()) % c.count])
        }
        
        return s
        
    }
    
}
