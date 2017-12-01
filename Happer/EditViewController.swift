//
//  EditViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 10..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import Spring
import RealmSwift

class EditViewController: UIViewController {
    
    var diary = Diary()
    var params: EditTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func touchDelete(_ sender: Any) {
        
        let alertController = UIAlertController(title: "삭제", message: "추억을 삭제하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
        
        let DestructiveAction = UIAlertAction(title: "아니오", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
        }
        
        let okAction = UIAlertAction(title: "네", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            let realm = try! Realm()
            
            try! realm.write {
                realm.delete(self.diary)
                
                self.dismissFunction()
            }
        }
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dismissFunction() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        params = segue.destination as? EditTableViewController
        
        params?.diary = diary
    }
    
    @IBAction func touchSave(_ sender: Any) {
        
        params?.saveDiary()
        
//        navigationController?.popViewController(animated: true)
//        
//        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
}
