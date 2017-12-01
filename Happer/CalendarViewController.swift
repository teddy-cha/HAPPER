//
//  CalendarViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 12..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var MonthTitle: UILabel!
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var isSelection = false
    
    func getDateString(date: Double) -> String {
        
        
        let raw = NSDate(timeIntervalSince1970: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone  = NSTimeZone.local
        
        return formatter.string(from: raw as Date)
        
    }
    
    
    var datesWithEvent = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefault = UserDefaults()
        let current = userDefault.double(forKey: "current")
        
//        self.calendar.select(NSDate(timeIntervalSince1970: current))
        
        calendar.select(Date(timeIntervalSince1970: current))
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.timeZone  = NSTimeZone.local
        
        MonthTitle.text = formatter.string(from: calendar.currentPage as Date)
        
        self.calendar.appearance.caseOptions = [.weekdayUsesUpperCase]
        
        let dateList = try! Realm().objects(Diary.self)
        
        for diary in dateList{
            
            if !datesWithEvent.contains(getDateString(date: diary.date)) {
                
                datesWithEvent.append(getDateString(date: diary.date))
                
            }
            
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func touchCancle(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.timeZone  = NSTimeZone.local
        
        MonthTitle.text = formatter.string(from: calendar.currentPage as Date)
        
        
        print(formatter.string(from: calendar.currentPage as Date))
        
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        if !isSelection {
//            
//            isSelection = true
//            
//        } else {
        
            if datesWithEvent.contains(getDateString(date: (calendar.selectedDate?.timeIntervalSince1970)!)) {
                
                let userDefault = UserDefaults()
                userDefault.set(calendar.selectedDate?.timeIntervalSince1970, forKey: "current")
                
                dismiss(animated: true, completion: nil)
                
            }
//        }
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return UIColor(red:0.81, green:0.83, blue:0.85, alpha:1.0)
        }
        return nil
    }

}
