//
//  GameTask.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 10/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

/*
 Esta clase representa cada una de las distintas tareas que
 se le pueden asignar a cada uno de los juegos seguidos por 
 el usuario de la aplicacion
 */

import Foundation
import SwiftyJSON

public enum TaskPriority : Int {
    
    case low
    case medium
    case high
    
}

public enum TaskDifficulty : Int {
    
    case easy
    case normal
    case hard
    
}

public class GameTask {
    
    var id: String = ""
    var idJuego: String = ""
    var title: String = ""
    var creationDate: Date?
    var priority: TaskPriority = .low
    var difficulty: TaskDifficulty = .easy
    
    var listaComponentesTask: Array<TaskComponent> = []
    
    init() {
        creationDate = Date()
    }
    
    init?(attributes: [String: Any]) {
        
        guard let id = (attributes["id"] as? JSON)?.string,
            let idJuego = (attributes["idJuego"] as? JSON)?.string,
            let titulo = (attributes["titulo"] as? JSON)?.string,
            let fecha = (attributes["fecha"] as? JSON)?.string,
            let prioridad = TaskPriority(rawValue: ((attributes["prioridad"] as? JSON)?.int)!),
            let dificultad = TaskDifficulty(rawValue: ((attributes["dificultad"] as? JSON)?.int)!),
            let componentes = (attributes["componentes"] as? JSON)?.array
            else {
                return nil
        }
        
        self.id = id
        self.idJuego = idJuego
        self.title = titulo
        self.priority = prioridad
        self.difficulty = dificultad
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss.sss"
        creationDate = dateFormatter.date(from: fecha)
        
        for componente in componentes {
            switch TaskComponentType(rawValue: (componente["tipo"].int)!)! {
            case .text:
                listaComponentesTask.append(TaskComponentText(attributes: componente.dictionary!)!)
            case .images:
                listaComponentesTask.append(TaskComponentImages(id: idJuego, attributes: componente.dictionary!)!)
            case .url:
                listaComponentesTask.append(TaskComponentURL(attributes: componente.dictionary!)!)
            case .counter:
                listaComponentesTask.append(TaskComponentCounter(attributes: componente.dictionary!)!)
            default:
                print("")
            }
        }
        
    }
    
    init?(attributes: [String: Any], listaComponentes: Array<TaskComponent>) {
        
        guard let id = (attributes["id"] as? JSON)?.string,
            let idJuego = (attributes["idJuego"] as? JSON)?.string,
            let titulo = (attributes["titulo"] as? JSON)?.string,
            let fecha = (attributes["fecha"] as? JSON)?.string,
            let prioridad = TaskPriority(rawValue: ((attributes["prioridad"] as? JSON)?.int)!),
            let dificultad = TaskDifficulty(rawValue: ((attributes["dificultad"] as? JSON)?.int)!)
            else {
                return nil
        }
        
        self.id = id
        self.idJuego = idJuego
        self.title = titulo
        self.priority = prioridad
        self.difficulty = dificultad
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss.sss"
        creationDate = dateFormatter.date(from: fecha)
        
        listaComponentesTask = listaComponentes
        
    }
    
}
