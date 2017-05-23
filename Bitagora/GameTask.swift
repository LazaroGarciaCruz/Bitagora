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
    
    var title: String = ""
    var subtitle: String = ""
    var creationDate: Date?
    var priority: TaskPriority = .low
    var difficulty: TaskDifficulty = .easy
    
    var listaComponentesTask: Array<TaskComponent> = []
    
    init(title: String, subtitle: String = "") {
        self.title = title
        self.subtitle = subtitle
        creationDate = Date()
    }
    
}
