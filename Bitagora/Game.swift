//
//  Game.swift
//  ViewTest
//
//  Created by Lazaro Garcia Cruz on 27/4/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

/*
 Esta clase va a representar cada uno de los juegos que gestiona la aplicacion
 */

import Foundation
import UIKit

public class Game {
    
    var title: String = ""
    var logoImage: UIImage?
    var coverImage: UIImage?
    var taskLista: Array<GameTask> = []
    
    init(title: String) {
        self.title = title
    }
    
}
