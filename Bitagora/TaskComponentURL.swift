//
//  TaskComponentURL.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 18/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TaskComponentURL: TaskComponent {
    
    public var isVideo = false
    public var url: String = ""
    
    override init() {
        super.init(type: TaskComponentType.url)
    }
    
    override init?(attributes: [String: Any]) {
        
        super.init(type: TaskComponentType.url)
        
        guard let isVideo = (attributes["isVideo"] as? JSON)?.bool,
        let url = (attributes["URL"] as? JSON)?.string
            else {
            return nil
        }
        
        self.isVideo = isVideo
        self.url = url
        
    }
    
}
