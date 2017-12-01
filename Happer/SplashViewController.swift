//
//  SplashViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 6. 1..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import RealmSwift

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
            performSegue(withIdentifier: "goMain", sender: self)
            
        } else {
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
            
            performSegue(withIdentifier: "goBackup", sender: self)
        }
    }
    
    

}
