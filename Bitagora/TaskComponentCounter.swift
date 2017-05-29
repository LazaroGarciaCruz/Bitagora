//
//  TaskComponentCounter.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 18/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TaskComponentCounter: TaskComponent {
    
    public var id: String = ""
    public var maxElements: Int = 0
    public var currentElementCount: Int = 0
    public var descripcion: String = ""
    
    override init() {
        super.init(type: TaskComponentType.counter)
        id = DataMaganer.sharedInstance.randomString(length: 10).uppercased()
    }
    
    override init?(attributes: [String: Any]) {
        
        super.init(type: TaskComponentType.counter)
        
        guard let id = (attributes["id"] as? JSON)?.string,
            let descripcion = (attributes["descripcion"] as? JSON)?.string,
            let maxElementos = (attributes["maxElementos"] as? JSON)?.int,
            let elementosActuales = (attributes["elementosActuales"] as? JSON)?.int
            else {
                return nil
        }
        
        self.id = id
        self.descripcion = descripcion
        self.maxElements = maxElementos
        self.currentElementCount = elementosActuales
        
    }
    
}
