//
//  TaskComponentImages.swift
//  Bitagora
//
//  Created by Lazaro Garcia Cruz on 18/5/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow

public class TaskComponentImages: TaskComponent {
    
    public var listaImagenes: Array<ImageSource> = []
    
    override init() {
        super.init()
        type = TaskComponentType.images
    }
    
}
