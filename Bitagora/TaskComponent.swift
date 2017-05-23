//
//  TaskComponent.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 18/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation

/*
 Esta clase representa cada uno de los componentes de una
 tarea que determinan sus caracteristicas particulares
 */

public enum TaskComponentType : Int {
    
    case none
    case text
    case images
    case counter
    case video
    case url
    
}

public class TaskComponent {

    var type: TaskComponentType = .none
    
    init() {
    }
    
}
