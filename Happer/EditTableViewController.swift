//
//  EditTableViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 11..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import RealmSwift

class EditTableViewController: UITableViewController, UITextViewDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var withTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var diaryTextView: UITextView!
    
    var diary = Diary()
    
     let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        withTextField.placeholder = "이름을 입력해주세요."
        placeTextField.placeholder = "장소를 입력해주세요."
        
        withTextField.text = getWithString()
        placeTextField.text = diary.locate
        imageView.image = getDiaryImage()
        diaryTextView.text = diary.diary_text
        diaryTextView.textAlignment = .center
        diaryTextView.delegate = self
        
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(EditTableViewController.keyboardWillShow(notification:)),
                           name: .UIKeyboardWillShow,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(EditTableViewController.keyboardWillHide(notification:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        diaryTextView.textAlignment = .center
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = getDiaryImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let params = segue.destination as? EditPhotoViewController
        
        params?.diary = diary
    }
    
    private func getDiaryImage() -> UIImage {
        if (diary.photo_path == "") {
            return UIImage().load(diary.cicle_path)
        } else {
            return UIImage().load(diary.photo_path)
        }
    }
    
    private func getWithString() -> String {
        var withSting = ""
        for i in 0..<diary.with.count {
            
            withSting += diary.with[i].name
            if (i != diary.with.count - 1) {
                withSting += ", "
            }
        }
        return withSting
    }
    
    public func saveDiary() {
        
        let points = withTextField.text ?? ""
        let pointsArr = points.components(separatedBy: ",")
        
        let newDiary = Diary()
        
        newDiary.id = diary.id
        newDiary.date = diary.date
        newDiary.cicle_path = diary.cicle_path
        newDiary.diary_text = diary.diary_text
        newDiary.photo_path = diary.photo_path
        newDiary.locate = diary.locate
        
        for i in 0..<pointsArr.count {
            
            if pointsArr[i] != "" {
                let person = Person()
                let name: String = pointsArr[i]
                
                if (name[0] == " ") {
                    person.name = name.substring(from: 1)
                } else {
                    person.name = pointsArr[i]
                }
                
                newDiary.with.append(person)
                
                try! realm.write {
                    realm.add(person, update: true)
                }
            }
        }
        
        newDiary.locate = placeTextField.text ?? ""
        newDiary.diary_text = diaryTextView.text
        
        try! realm.write {
            realm.add(newDiary, update: true)
        }
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }


}

extension UITableViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
