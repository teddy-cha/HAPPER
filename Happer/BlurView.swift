//
//  BlurView.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 21..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit

class BlurView: UIImageView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
//
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    

}
