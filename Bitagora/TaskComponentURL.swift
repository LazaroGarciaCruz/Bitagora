//
//  TaskComponentURL.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 18/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation

public class TaskComponentURL: TaskComponent {
    
    public var isVideo = false
    public var url: String = ""
    
    override init() {
        super.init()
        type = TaskComponentType.url
    }
    
}
