//
//  MindView.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 6. 1..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import Spring

class MindView: SpringView {
    
    let gradient = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        
//        let gradient = CAGradientLayer()
        
//        self.backgroundColor = UIColor.clear
//        
//        gradient.frame = self.bounds
//        gradient.colors = [UIColor(red:1.00, green:0.77, blue:0.77, alpha:1.0).cgColor, UIColor(red:1.00, green:0.00, blue:0.38, alpha:1.0).cgColor]
//        gradient.cornerRadius = self.frame.width / 2
//        
//        self.layer.insertSublayer(gradient, at: 0)
//        self.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    public func setGradient(index: Int) {
        self.backgroundColor = UIColor.clear
        
        gradient.frame = self.bounds
//        gradient.colors = [UIColor(red:1.00, green:0.77, blue:0.77, alpha:1.0).cgColor, UIColor(red:1.00, green:0.00, blue:0.38, alpha:1.0).cgColor]
        gradient.colors = [Colors.fromColorList[index], Colors.fromColorList[index + 1]]
        gradient.cornerRadius = self.frame.width / 2
        
        self.layer.insertSublayer(gradient, at: 0)
        self.translatesAutoresizingMaskIntoConstraints = true
    }

    func mindAnimation(animation: CABasicAnimation) {
        
        gradient.add(animation, forKey: "animateGradient")
        
    }
    
    
}

//@implementation UIView (ColorOfPoint)
//
//- (UIColor *)colorOfPoint:(CGPoint)point {
//    unsigned char pixel[4] = {0};
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
//    
//    CGContextTranslateCTM(context, -point.x, -point.y);
//    
//    [self.layer renderInContext:context];
//    
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    
//    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
//    
//    return color;
//}
