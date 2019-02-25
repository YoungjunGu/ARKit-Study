//
//  Planet.swift
//  solarsystem
//
//  Created by youngjun goo on 07/11/2018.
//  Copyright © 2018 youngjun goo. All rights reserved.
//

import UIKit

class Planet {
    
    var name: String
    var radius: CGFloat
    var rotation: CGFloat
    var color: UIColor
    var sunDistance: Float
    
    init(name: String, radius: CGFloat, rotation: CGFloat, color: UIColor, sunDistance: Float) {
        
        self.name = name
        self.radius = radius
        self.rotation = rotation
        self.color = color
        self.sunDistance = sunDistance
        
    }
    
    
}
