//
//  TaskComponentCounter.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 18/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation

public class TaskComponentCounter: TaskComponent {
    
    public var maxElements: Int = 0
    public var currentElementCount: Int = 0
    public var descripcion: String = ""
    
    override init() {
        super.init()
        type = TaskComponentType.counter
    }
    
}
