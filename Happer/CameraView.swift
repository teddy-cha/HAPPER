//
//  CameraView.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 4..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit

class CameraView: UIView {

    override func draw(_ rect: CGRect) {
        
        
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true;
    }

}
