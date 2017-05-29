//
//  TaskComponentText.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 18/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TaskComponentText: TaskComponent {
    
    public var texto: String = ""
    
    override init() {
        super.init(type: TaskComponentType.text)
    }
    
    override init?(attributes: [String: Any]) {
        
        super.init(type: TaskComponentType.text)
        
        guard let texto = (attributes["texto"] as? JSON)?.string else {
                return nil
        }
        
        self.texto = texto
        
    }
    
}
