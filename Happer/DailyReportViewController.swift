//
//  DailyReportViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 8..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import RealmSwift

class DailyReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var diaryList = try! Realm().objects(Diary.self)
    
    var selectDiary: Diary = Diary()
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Along with auto layout, these are the keys for enabling variable cell height
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let datePress = UITapGestureRecognizer(target: self, action: #selector(touchDate(gesture:)))
        dateLabel.addGestureRecognizer(datePress)
        
        
    }
    
    func touchDate(gesture: UITapGestureRecognizer) {
        
        print("**********")
        
        self.performSegue(withIdentifier: "goCalendar", sender: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let userDefault = UserDefaults()
        dateLabel.text = getDateString(date: userDefault.double(forKey: "current"))
        
        let currentDate = Date(timeIntervalSince1970: userDefault.double(forKey: "current"))
        print("date >= \(currentDate.startOfDay.timeIntervalSince1970) AND date <= \(currentDate.endOfDay!.timeIntervalSince1970)")
        diaryList = try! Realm()
            .objects(Diary.self)
            .filter("date >= \(currentDate.startOfDay.timeIntervalSince1970) AND date <= \(currentDate.endOfDay!.timeIntervalSince1970)").sorted(byKeyPath: "date", ascending: false)
        
        
        if diaryList.count == 0 {
            self.emptyView.alpha = 1
        } else {
            self.emptyView.alpha = 0
        }
        
        tableView.reloadData()
    }
    
    
    
    @IBAction func touchAdd(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let diary = diaryList[indexPath.row]
        
        var image: UIImage
        
        if (diary.photo_path == "") {
            image = UIImage().load(diary.cicle_path)
        } else {
            image = UIImage().load(diary.photo_path)
        }
        
        let timeStr = getTimeString(date: diary.date)
        
        /**
         * #01
         */
        
        if (diary.photo_path == "" && diary.diary_text == "" && diary.with.count == 0) {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "oneCell") as! OneTableViewCell
            cell.cellImageView.image = image
            cell.time.text = timeStr
            cell.location.setTitle(diary.locate, for: .normal)
            
            return cell
        }
        
        /**
         * #02
         */
        
        if (diary.photo_path == "" && diary.diary_text == "" && diary.with.count != 0) {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "twoCell") as! TwoTableViewCell
            
            cell.cellImageView.image = image
            cell.time.text = timeStr
            cell.location.setTitle(diary.locate, for: .normal)
            cell.with.text = getWithString(diary.with)
            
            return cell
        }
        
        /**
         * #03
         */
        
        if (diary.photo_path != "" && diary.diary_text == "" && diary.with.count == 0) {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "oneCell") as! OneTableViewCell
            cell.cellImageView.image = image
            cell.time.text = timeStr
            cell.location.setTitle(diary.locate, for: .normal)
            
            return cell
        }
        
        /**
         * #04
         */
        
        if (diary.photo_path == "" && diary.diary_text != "" && diary.with.count == 0) {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "threeCell") as! ThreeTableViewCell
            
            cell.cellImageView.image = image
            cell.time.text = timeStr
            cell.location.setTitle(diary.locate, for: .normal)
            cell.diaryText.text = diary.diary_text
            
            return cell
        }
        
        /**
         * #05
         */
        
        if (diary.photo_path == "" && diary.diary_text != "" && diary.with.count != 0) {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "sixCell") as! SixTableViewCell
            
            cell.cellImageView.image = image
            cell.time.text = timeStr
            cell.location.setTitle(diary.locate, for: .normal)
            cell.diaryText.text = diary.diary_text
            cell.with.text = getWithString(diary.with)
            
            return cell
        }
        
        /**
         * #06
         */
        
        if (diary.photo_path != "" && diary.diary_text == "" && diary.with.count != 0) {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "fiveCell") as! FiveTableViewCell
            
            cell.cellImageView.image = image
            cell.time.text = timeStr
            cell.location.setTitle(diary.locate, for: .normal)
            cell.with.text = getWithString(diary.with)
            
            return cell
        }
        
        /**
         * #07
         */
        
        if (diary.photo_path != "" && diary.diary_text != "" && diary.with.count == 0) {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "threeCell") as! ThreeTableViewCell
            
            cell.cellImageView.image = image
            cell.time.text = timeStr
            cell.location.setTitle(diary.locate, for: .normal)
            cell.diaryText.text = diary.diary_text
            
            return cell
        }
        
        /**
         * #08
         */
        
        if (diary.photo_path != "" && diary.diary_text != "" && diary.with.count != 0) {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "fourCell") as! FourTableViewCell
            
            cell.cellImageView.image = image
            cell.time.text = timeStr
            cell.location.setTitle(diary.locate, for: .normal)
            cell.diaryText.text = diary.diary_text
            cell.with.text = getWithString(diary.with)
            
            return cell
        }
        
        return self.tableView.dequeueReusableCell(withIdentifier: "oneCell") as! OneTableViewCell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goEdit" {
            let param = segue.destination as! EditViewController
            
            param.diary = selectDiary
        } 
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        selectDiary = diaryList[indexPath.row]
        
        self.performSegue(withIdentifier: "goEdit", sender: self)
    }

    func getDiaryType(_ diary: Diary) -> Int {
        return 0
    }
    
    func getTimeString(date: Double) -> String {
        
        
        let raw = NSDate(timeIntervalSince1970: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.timeZone  = NSTimeZone.local
        
        return formatter.string(from: raw as Date)
        
    }
    
    func getDateString(date: Double) -> String {
        
        
        let raw = NSDate(timeIntervalSince1970: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd" + NSLocalizedString("date_language", comment: "")
        formatter.timeZone  = NSTimeZone.local
        
        return formatter.string(from: raw as Date)
        
    }
    
    func getWithString(_ person: List<Person>) -> String {
        
        var withString = ""
        
        for i in 0..<person.count {
            withString += "#"
            withString += person[i].name
            
            if i != person.count - 1 {
                withString += ", "
            }
        }
        
        return withString
        
    }

}


extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}
