//
//  BackUpViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 6. 1..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import Spring

class BackUpViewController: UIViewController {
        
        @IBOutlet weak var nextTimeButton: SpringView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(clickNext(gesture:)))
            
            nextTimeButton.addGestureRecognizer(gesture)
            
        }
        
        func clickNext(gesture: UITapGestureRecognizer) {
            
            performSegue(withIdentifier: "goMain", sender: self)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
}
