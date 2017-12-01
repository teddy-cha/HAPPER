//
//  DiaryTextViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 7..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import Spring

class DiaryTextViewController: UIViewController {
    
    var mindLayer: CALayer = CALayer()

    @IBOutlet weak var textView: SpringTextView!
    
    var diary = Diary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    @IBAction func touchAdd(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let param = segue.destination as! CameraViewController
        
        diary.diary_text = textView.text ?? ""
        diary.toString()
        
        param.diary = diary
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.view.layer.addSublayer(mindLayer)
        
        UIView.animate(withDuration: 1.5 ,animations: {
        }, completion: {
            (value: Bool) in
            self.textView.becomeFirstResponder()
        })
    }

    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
        }
    }
}
