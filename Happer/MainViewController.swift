//
//  MainViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 6. 1..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import Spring
import RealmSwift
import CoreLocation
import Zip
import SwiftyDropbox
import SwiftSpinner
import AVFoundation

class MainViewController: UIViewController, CAAnimationDelegate {
    
    // 원을 누르기 전 화면에 대한 구성 요소
    @IBOutlet weak var detailInputView: UIView!
    @IBOutlet weak var titleLabel: SpringLabel!
    @IBOutlet weak var guideTextLabel: SpringLabel!
    @IBOutlet weak var mind: MindView!
    @IBOutlet weak var pastButton: SpringView!
    @IBOutlet weak var emitterView: UIView!
    @IBOutlet weak var chartButton: SpringButton!
    @IBOutlet weak var backupButton: SpringButton!
    
    var toColors : [CGColor]?
    var fromColors : [CGColor]?
    
    var index: Int = 0
    var finish: Bool = false
    
    var gradient : CAGradientLayer?
    let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
    let gen = UIImpactFeedbackGenerator(style: .light)
    let emitter = CAEmitterLayer()
    var emitterList: [CAEmitterCell] = []
    
    var realm = try! Realm()
    var diary = Diary()
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameTextField: SpringTextField!
    @IBOutlet weak var nameLabel: SpringLabel!
    
    
    class MindLongPressGesture : UILongPressGestureRecognizer {
        var startTime : NSDate?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1차 객체 초기화
        diary = Diary()
        diary.id = diary.incrementID()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // 길게 터치, 짧게 터치 하는 제스처 등록
        let longPress = MindLongPressGesture(target: self, action: #selector(longPress(gesture:)))
        let shortPress = UITapGestureRecognizer(target: self, action: #selector(shortPress(gesture:)))
        let passPress = UITapGestureRecognizer(target: self, action: #selector(touchPast(gesture:)))
        
        mind.addGestureRecognizer(longPress)
        mind.addGestureRecognizer(shortPress)
        pastButton.addGestureRecognizer(passPress)
        
        let center = NotificationCenter.default
        
        center.addObserver(self,
                           selector: #selector(keyboardWillShow(_:)),
                           name: .UIKeyboardWillShow,
                           object: nil)
        
        let userDefault = UserDefaults()
        userDefault.set(NSDate().timeIntervalSince1970, forKey: "current")
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized {
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
                
                if granted {
                } else {
                }
            })
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        index = Int(arc4random_uniform(10) + 1)
        
        if (index >= 3 && index <= 7) {
            index = 0
        }
        
        mind.setGradient(index: index)
        
        diary = Diary()
        diary.id = diary.incrementID()
        
        // Animation 셋팅 (퍼지는 효과)
        emitter.frame = self.emitterView.bounds
        emitter.renderMode = kCAEmitterLayerAdditive
        emitter.emitterPosition = CGPoint(x: emitterView.center.x, y: emitterView.center.y / 2)
        self.emitterView.layer.addSublayer(emitter)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = true
        self.pastButton.translatesAutoresizingMaskIntoConstraints = true
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
    }
    
    func touchPast(gesture: UITapGestureRecognizer) {
        
        self.performSegue(withIdentifier: "goDaily", sender: self)
        
    }
    
    @IBAction func touchAdd(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func touchBackup(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Dropbox 백업", message: "Dropbox를 통해\n 백업하거나 복구할 수 있습니다.", preferredStyle: .alert)
        
        let oneAction = UIAlertAction(title: "Dropbox로 백업하기", style: .default) { _ in
            self.toBackup()
        }
        let twoAction = UIAlertAction(title: "Dropbox로 복구하기", style: .default) { _ in
            self.getBackup()
        }
        let cancelAction = UIAlertAction(title: "다음에 하기", style: .cancel) { _ in }
        
        alertController.addAction(oneAction)
        alertController.addAction(twoAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
//        let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
//
//        let fileManager = FileManager.default
//        let enumerator = fileManager.enumerator(atPath: (localDocumentsURL.path))
//        var urlPaths = [URL]()
//        
//        while let file = enumerator?.nextObject() as? String {
//            urlPaths.append(localDocumentsURL.appendingPathComponent("default.realm"))
//    
//            if file.contains("png") {
//                urlPaths.append(localDocumentsURL.appendingPathComponent(file))
//                print(localDocumentsURL.appendingPathComponent(file))
//        
//            }
//        }
        
        
//        if let client = DropboxClientsManager.authorizedClient {
//            do {
//                let fileData = try Data(contentsOf: localDocumentsURL.appendingPathComponent("Archive.zip"))
//                
//                let _ = client.files.upload(path: "/Archive.zip", input: fileData)
//                    .response { response, error in
//                        if let response = response {
//                            print(response)
//                        } else if let error = error {
//                            print(error)
//                        }
//                    }
//                    .progress { progressData in
//                        print(progressData)
//                }
//            } catch let error as NSError {
//                print("Error: \(error)")
//            }
//            
//         } else {
//            DropboxClientsManager.authorizeFromController(UIApplication.shared,
//                                                          controller: self,
//                                                          openURL: { (url: URL) -> Void in
//                                                            UIApplication.shared.openURL(url)
//            })
//        }
//
        
    }
    
    func toBackup() {
        
        if let client = DropboxClientsManager.authorizedClient {
            
            let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
            
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: (localDocumentsURL.path))
            var urlPaths = [URL]()
            
            while let file = enumerator?.nextObject() as? String {
                urlPaths.append(localDocumentsURL.appendingPathComponent("default.realm"))
                
                if file.contains("png") {
                    urlPaths.append(localDocumentsURL.appendingPathComponent(file))
                    print(localDocumentsURL.appendingPathComponent(file))
                    
                }
            }
            
            do {
                let filePath = localDocumentsURL.appendingPathComponent("Archive.zip")
                
//                try Zip.zipFiles(urlPaths, zipFilePath: filePath, password: "", progress: { (progress) -> () in
//                    print(progress)
//                })
                
                let _ = try Zip.quickZipFiles(urlPaths, fileName: "Archive")
            } catch let error as NSError {
                let alertController = UIAlertController(title: "백업실패", message: "죄송합니다. 백업중에 오류가 발생하였습니다.\n Error: \(error)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            
            do {
                let fileData = try Data(contentsOf: localDocumentsURL.appendingPathComponent("Archive.zip"))
                
                let _ = client.files.upload(path: "/Archive.zip", mode: .overwrite ,input: fileData)
                    .response { response, error in
                        if let response = response {
                            print(response)
                            
                            let alertController = UIAlertController(title: "백업완료", message: "백업이 완료되었습니다.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            alertController.addAction(okAction)
                            SwiftSpinner.hide()
                            self.present(alertController, animated: true, completion: nil)
                            
                        } else if let error = error {
                            print(error)
                            
                            let alertController = UIAlertController(title: "백업실패", message: "죄송합니다. 백업중에 오류가 발생하였습니다.\n Error: \(error)", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            alertController.addAction(okAction)
                            SwiftSpinner.hide()
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    .progress { progressData in
                        
                        SwiftSpinner.show("업로드 중입니다.")
                        
                }
            } catch let error as NSError {
                print("Error: \(error)")
                let alertController = UIAlertController(title: "백업실패", message: "죄송합니다. 백업중에 오류가 발생하였습니다.\n Error: \(error)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                alertController.addAction(okAction)
                SwiftSpinner.hide()
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: self,
                                                          openURL: { (url: URL) -> Void in
                                                            UIApplication.shared.openURL(url)
            })
        }

    }
    
    func getBackup() {
        
        if let client = DropboxClientsManager.authorizedClient {
            
            let fileManager = FileManager.default
            let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destURL = directoryURL.appendingPathComponent("Archive.zip")
            let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                return destURL
            }
            client.files.download(path: "/Archive.zip", overwrite: true, destination: destination)
                .response { response, error in
                    if let response = response {
                        
                        let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
                        
                        CloudDataManager.sharedInstance.deleteFilesInDirectory(url: localDocumentsURL)
                        
                        
                        do {
                            let filePath = localDocumentsURL.appendingPathComponent("Archive.zip")
                            let documentsDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
                            try Zip.unzipFile(filePath, destination: documentsDirectory, overwrite: true, password: "", progress: { (progress) -> () in
                                print(progress)
                            })
                            
                            let alertController = UIAlertController(title: "복구완료", message: "복구가 완료되었습니다. 앱을 재시작 해주세요.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            alertController.addAction(okAction)
                            SwiftSpinner.hide()
                            self.present(alertController, animated: true, completion: nil)
                            
                            
                        } catch let error as NSError {
                            let alertController = UIAlertController(title: "복구실패", message: "죄송합니다. 복구중에 오류가 발생하였습니다.\n Error: \(error)", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            alertController.addAction(okAction)
                            SwiftSpinner.hide()
                            self.present(alertController, animated: true, completion: nil)

                        }
                    } else if let error = error {
                        print(error)
                        let alertController = UIAlertController(title: "복구실패", message: "죄송합니다. 복구중에 오류가 발생하였습니다.\n Error: \(error)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        alertController.addAction(okAction)
                        SwiftSpinner.hide()
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                .progress { progressData in
                    SwiftSpinner.show("다운로드 중입니다.")
            }
            
        } else {
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: self,
                                                          openURL: { (url: URL) -> Void in
                                                            UIApplication.shared.openURL(url)
            })
        }
        
    }
    
    @IBAction func shortPress(gesture: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.4 ,animations: {
            self.guideTextLabel.alpha = 0
        }, completion: {
            (value: Bool) in
            
            // 바로 입력시 초기화 작업 한 번더 진행.
            self.diary = Diary()
            self.diary.id = self.diary.incrementID()
            self.diary.date = NSDate().timeIntervalSince1970
            
            if !CLLocationManager.locationServicesEnabled() ||
                CLLocationManager.authorizationStatus() == .notDetermined ||
                CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied {
                
                if let layer = self.mind.layer.presentation() {
                    let image = UIImage(layer: layer, view: self.mind)
                    image.save("\(self.diary.id)circle.png")
                    self.diary.cicle_path = "\(self.diary.id)circle.png"
                }
                
                try! self.realm.write {
                    self.realm.add(self.diary, update: true)
                }
                
                self.performSegue(withIdentifier: "goDaily", sender: self)
                
            } else {
                
                self.getAddressString()
            }
        })
    }
    
    @IBAction func longPress(gesture: MindLongPressGesture) {
        
        gen.prepare()
        
        if gesture.state == .began {
            gesture.startTime = NSDate()
            UIView.animate(withDuration: 0.2 ,animations: {
                self.guideTextLabel.alpha = 0
            }, completion: nil)
            animateLayer()
            gen.impactOccurred()
            
        } else if gesture.state == .ended {
            let duration = NSDate().timeIntervalSince(gesture.startTime! as Date)
            print("duration was \(duration) seconds")
            
            self.finish = true
            self.animationDidStop(animation, finished: true)
            
            UIView.animate(withDuration: 0.4 ,animations: {
                self.emitterView.alpha = 0
            }, completion: {
                (value: Bool) in
                self.removeEmitter()
            })
            
            UIView.animate(withDuration: 0.8 ,animations: {
                
                self.pastButton.animation = "fadeOut"
                self.pastButton.duration = 1.2
                self.pastButton.animate()
                
                self.chartButton.animation = "fadeOut"
                self.chartButton.duration = 1.2
                self.chartButton.animate()
                
                self.backupButton.animation = "fadeOut"
                self.backupButton.duration = 1.2
                self.backupButton.animate()
                
                let yValue = self.mind.frame.origin.y + (self.mind.frame.height * 0.75)
                self.mind.frame.origin.y -= yValue
                self.titleLabel.alpha = 0
                self.pastButton.frame.origin.y += 130
                self.chartButton.frame.origin.x += 130
                self.backupButton.frame.origin.x += 180
                
            }, completion: {
                (value: Bool) in
                self.showDetailInputView()
            })
        }
    }
    
    @IBAction func touchNext(_ sender: Any) {
        
        nameTextField.endEditing(true)
        
        if let layer = mind.layer.presentation() {
            let image = UIImage(layer: layer, view: mind)
            image.save("\(diary.id)circle.png")
        }
        
        UIView.animate(withDuration: 0.5 ,animations: {
            self.nameTextField.alpha = 0
            self.nameLabel.alpha = 0
            self.commentLabel.alpha = 0
        }, completion: {
            (value: Bool) in
            self.performSegue(withIdentifier: "goWhere", sender: self)
        })
        
    }
    
    func showDetailInputView() {
        detailInputView.alpha = 1
        nameTextField.animate()
        //        nextButton.animate()
        nameLabel.animate()
        commentLabel.alpha = 1
        
        nameTextField.becomeFirstResponder()
    }
    
    func animateLayer(){
        
        if index == 11 {
            addEmitter(a: index, b: 0)
            fromColors = [Colors.fromColorList[index], Colors.fromColorList[0]]
            toColors = [Colors.toColorList[index], Colors.toColorList[0]]
            index = 0
        } else {
            addEmitter(a: index, b: index + 1)
            fromColors = [Colors.fromColorList[index], Colors.fromColorList[index+1]]
            toColors = [Colors.toColorList[index], Colors.toColorList[index+1]]
            index += 1
        }
        
        
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 0.50
        
        mind.mindAnimation(animation: animation)
        
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if flag && !finish{
            
            animateLayer()
        }
    }
    
    func addEmitter(a: Int, b: Int) {
        
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "cicle")?.cgImage
        cell.scale = 0.3
        cell.birthRate = 15
        cell.lifetime = 5.0
        cell.color = Colors.toColorList[a]
        cell.alphaSpeed = -0.4
        cell.velocity = 50
        cell.velocityRange = 250
        cell.emissionRange = CGFloat(Double.pi) * 2.0
        
        let cell2 = CAEmitterCell()
        cell2.contents = UIImage(named: "cicle")?.cgImage
        cell2.scale = 0.25
        cell2.birthRate = 25
        cell2.lifetime = 5.0
        cell2.color = Colors.toColorList[b]
        cell2.alphaSpeed = -0.3
        cell2.velocity = 50
        cell2.velocityRange = 250
        cell2.emissionRange = CGFloat(Double.pi) * 2.0
        
        emitterList = [cell, cell2]
        
        emitter.emitterCells = emitterList
    }
    
    func removeEmitter() {
        emitterList = []
        
        emitter.emitterCells = emitterList
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goWhere" {
            
            let param = segue.destination as! PlaceViewController
            
            diary.cicle_path = "\(diary.id)circle.png"
            diary.date = NSDate().timeIntervalSince1970
            
            let points = nameTextField.text ?? ""
            let pointsArr = points.components(separatedBy: ",")
            
            for i in 0..<pointsArr.count {
                
                if pointsArr[i] != "" {
                    let person = Person()
                    let name: String = pointsArr[i]
                    
                    if (name[0] == " ") {
                        person.name = name.substring(from: 1)
                    } else {
                        person.name = pointsArr[i]
                    }
                    
                    diary.with.append(person)
                    
                    try! realm.write {
                        realm.add(person, update: true)
                    }
                }
            }
            
            diary.toString()
            
            param.mindLayer = mind.layer
            param.diary = diary
            
        }
        
    }
    
    func getAddressString(){
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            let state: String = placeMark.addressDictionary!["State"] as? String ?? ""
            let city: String = placeMark.addressDictionary!["City"] as? String ?? ""
            let subLocality: String = placeMark.addressDictionary!["SubLocality"] as? String ?? ""
            
            if let countryCode = placeMark.addressDictionary!["CountryCode"] as? String {
                
                var locationString = ""
                
                if countryCode == "KR" || countryCode == "JP" || countryCode == "CN" {
                    locationString = state + " " + city + " " + subLocality
                } else {
                    locationString = subLocality + " " + city + " " + state
                }
                self.diary.locate = locationString
                
                self.saveDiary()
            }
            
        })
    }
    
    func saveDiary() {
        
        if let layer = self.mind.layer.presentation() {
            let image = UIImage(layer: layer, view: self.mind)
            image.save("\(self.diary.id)circle.png")
        }
        self.diary.cicle_path = "\(self.diary.id)circle.png"
        
        self.diary.toString()
        
        try! self.realm.write {
            self.realm.add(self.diary, update: true)
        }
        
        self.performSegue(withIdentifier: "goDaily", sender: self)
    }
    
    
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            _ = keyboardRectangle.height
            
        }
    }

    
}

public extension UIImage {
    /// 이미지 저장.
    func save(_ name: String) {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let url = URL(fileURLWithPath: path).appendingPathComponent(name)
        try! UIImagePNGRepresentation(self)?.write(to: url)
        print("saved image at \(url)")
    }
    
    func load(_ name: String) -> UIImage {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let url = URL(fileURLWithPath: path).appendingPathComponent(name)
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)!
        } catch {
            print("Error loading image : \(error)")
        }
        
        return UIImage()
    }
}

extension UIImage {
    public convenience init(layer: CALayer, view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}
