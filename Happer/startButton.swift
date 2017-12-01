//
//  startButton.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 22..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit

class startButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
        self.layer.cornerRadius = 18
    }
 

}
