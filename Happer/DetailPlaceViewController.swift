//
//  DetailPlaceViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 6. 1..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import Spring

class DetailPlaceViewController: UIViewController {
    
    var mindLayer: CALayer = CALayer()
    var titleLayer: CALayer = CALayer()
    
    @IBOutlet weak var DI_guideTextLabel: SpringLabel!
    @IBOutlet weak var placeTextField: SpringTextField!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var skipButton: RadiusSpringButton!
    @IBOutlet weak var nextButton: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.hideKeyboardWhenTappedAround()
//        
//        let noti_center = NotificationCenter.default
//        
//        noti_center.addObserver(self,
//                           selector: #selector(DetailPlaceViewController.keyboardWillShow(notification:)),
//                           name: .UIKeyboardWillShow,
//                           object: nil)
//        noti_center.addObserver(self,
//                           selector: #selector(DetailPlaceViewController.keyboardWillHide(notification:)),
//                           name: .UIKeyboardWillHide,
//                           object: nil)
//        
//        self.placeTextField.delegate = self as UITextFieldDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.view.layer.addSublayer(mindLayer)
        self.view.layer.addSublayer(titleLayer)
        
        
//        let image = UIImage(layer: mindLayer, view: self.view)
//        UIImageWriteToSavedPhotosAlbum(image, self,  nil, nil);
        
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        mindLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, self,  nil, nil);

        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        let param = segue.destination as! DetailPlaceViewController
//        
//        param.mindLayer = mindLayer
//        param.titleLayer = titleLayer
//        
//    }
    
    
//    func keyboardWillShow(notification:NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    func keyboardWillHide(notification:NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
}

//extension DetailPlaceViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        placeTextField.endEditing(true)
//
//        return true
//    }
//}

//extension UIImage {
//    convenience init(layer: CALayer, view: UIView) {
//        UIGraphicsBeginImageContext(view.frame.size)
//        layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.init(cgImage: (image?.cgImage)!)
//    }
//}

