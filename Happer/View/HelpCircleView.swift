//
//  HelpCircleView.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 12. 13..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit

class HelpCircleView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0).cgColor
        
    }
    
}
