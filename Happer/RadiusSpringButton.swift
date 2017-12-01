//
//  RadiusSpringButton.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 6. 2..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import Spring

class RadiusSpringButton: SpringButton {

    override func draw(_ rect: CGRect) {
    
        self.clipsToBounds = true
        self.layer.cornerRadius = 14
        
    }
}
