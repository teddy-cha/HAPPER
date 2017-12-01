//
//  Diary.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 8..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import RealmSwift

class Diary: Object {
    
    dynamic var id = 0
    let with = List<Person>()
    dynamic var locate = ""
    dynamic var diary_text = ""
    dynamic var cicle_path = ""
    dynamic var photo_path = ""
    dynamic var date = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Diary.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func toString() {
        print("==========DIARY===========")
        print("id :: \(id)")
        print("with :: \(with)")
        print("locate :: \(locate)")
        print("diary_text :: \(diary_text)")
        print("cicle_path :: \(cicle_path)")
        print("photo_path :: \(photo_path)")
        print("date :: \(date)")
        print("==========================")
    }

}

class Person: Object {
    dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
