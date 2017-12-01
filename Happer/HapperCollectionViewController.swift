//
//  HapperCollectionViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 17..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import RealmSwift

class HapperCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var diary = try! Realm().objects(Diary.self)
    var withs = Array<String>()
    var locations = Array<String>()
    var diary_texts = Array<String>()
    
    var nameParam: NameCollectionViewController?
    var placeParam: PlaceCollectionViewController?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let datePress = UITapGestureRecognizer(target: self, action: #selector(touchDate(gesture:)))
        headDateLabel.addGestureRecognizer(datePress)
    }
    
    func touchDate(gesture: UITapGestureRecognizer) {
        
        print("**********")
        
        self.performSegue(withIdentifier: "goCalendar", sender: self)
        
    }
    
    @IBAction func touchBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        let userDefault = UserDefaults()
        let currentDate = Date(timeIntervalSince1970: userDefault.double(forKey: "current"))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM"
        dateFormatter.timeZone = TimeZone.current
        
        headDateLabel.text = dateFormatter.string(from: currentDate)
        
        dateFormatter.dateFormat = "M"
        titleLabel.text = dateFormatter.string(from: currentDate) + "월\n행복했던 순간들"
        
        
        diary = try! Realm()
            .objects(Diary.self)
            .filter("date >= \(currentDate.startOfMonth?.timeIntervalSince1970 ?? 0) AND date <= \(currentDate.endOfMonth?.timeIntervalSince1970 ?? 0)")
        
        getDiaryList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "name" {
            
            nameParam = segue.destination as? NameCollectionViewController
            nameParam?.withs = withs
            
        } else if (segue.identifier == "place") {
            placeParam = segue.destination as? PlaceCollectionViewController
            placeParam?.locations = locations
        }
        
    }
    
    
    func getDiaryList() {
        
        var with_array = Array<String>()
        var location_array = Array<String>()
        
        for item in diary {
            for person in item.with {
                with_array.append(person.name)
            }
            
            location_array.append(item.locate)
            
            if (item.diary_text != "" ) {
                 diary_texts.append(item.diary_text)
                
                print("-------")
                print(item.diary_text)
                print("-------")
            }
        }
        
        withs = Array(Set(with_array))
        locations = Array(Set(location_array))
        
        nameParam?.withs = withs
        nameParam?.collectionView?.reloadData()
        
        placeParam?.locations = locations
        placeParam?.collectionView?.reloadData()
        
        collectionView.reloadData()
        
        print(withs)
        print(locations)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(collectionView.tag)
        
        return diary_texts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizeOfString = CGSize()
        if let font = UIFont(name: "NanumMyeongjo", size: 16.0) {
            let finalDate = diary_texts[indexPath.row]
            let fontAttributes = [NSFontAttributeName: font]
            sizeOfString = (finalDate as NSString).size(attributes: fontAttributes)
        }
        
        if sizeOfString.width >= 180 {
            return CGSize(width: 200, height: 300)
        }
        
        return CGSize(width: sizeOfString.width + 20, height: 300)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath) as! DiaryTextCollectionViewCell
        
        cell.daily_text.text = diary_texts[indexPath.row]
        
        return cell
        
    }

}

extension Date {
    
    var startOfMonth: Date? {
        
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: currentDateComponents)
        
        return startOfMonth
    }
    
    func dateByAddingMonths(_ monthsToAdd: Int) -> Date? {
        
        let calendar = Calendar.current
        var months = DateComponents()
        months.month = monthsToAdd
        
        return calendar.date(byAdding: months, to: self)
    }
    
    var endOfMonth: Date? {
        
        guard let plusOneMonthDate = dateByAddingMonths(1) else { return nil }
        
        let calendar = Calendar.current
        let plusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: plusOneMonthDate)
        let endOfMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1)
        
        return endOfMonth
    }
    
}
