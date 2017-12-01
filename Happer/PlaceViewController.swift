//
//  TestViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 6..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import Spring
import CoreLocation

class PlaceViewController: UIViewController {
    
    var mindLayer: CALayer = CALayer()

    @IBOutlet weak var currentLocationButton: SpringButton!
    @IBOutlet weak var placeLabel: SpringLabel!
    @IBOutlet weak var locateConst: NSLayoutConstraint!
    @IBOutlet weak var placeTextInput: SpringTextField!
    var locationManager:CLLocationManager!
    
    var diary = Diary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        if CLLocationManager.locationServicesEnabled() &&
            CLLocationManager.authorizationStatus() != .notDetermined &&
            CLLocationManager.authorizationStatus() != .restricted &&
            CLLocationManager.authorizationStatus() != .denied {
            
            getAutoAddressString()
        
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @IBAction func touchAdd(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func touchDiary(_ sender: Any) {
        
        placeTextInput.endEditing(true)
        UIView.animate(withDuration: 0.5 ,animations: {
            
            self.currentLocationButton.alpha = 0
            self.placeLabel.alpha = 0
            self.placeTextInput.alpha = 0
            
        }, completion: {
            (value: Bool) in
            self.performSegue(withIdentifier: "goDiary", sender: self)
        })

    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.view.layer.addSublayer(mindLayer)
        
        UIView.animate(withDuration: 2.5 ,animations: {
        }, completion: {
            (value: Bool) in
            self.placeTextInput.becomeFirstResponder()
        })
    }
    
    func getAddressString() {
        
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
                
                if countryCode == "KR" || countryCode == "JP" || countryCode == "CN" {
                    self.placeTextInput.text = state + " " + city + " " + subLocality
                } else {
                    self.placeTextInput.text = subLocality + " " + city + " " + state
                }
            }
        })
    }
    
    func getAutoAddressString() {
        
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
                
                if countryCode == "KR" || countryCode == "JP" || countryCode == "CN" {
                    self.diary.locate = state + " " + city + " " + subLocality
                } else {
                     self.diary.locate = subLocality + " " + city + " " + state
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let param = segue.destination as! DiaryTextViewController
        
        if (placeTextInput.text ?? "" != "") {
            
            diary.locate = placeTextInput.text ?? ""
        
        }
        diary.toString()
        
        param.mindLayer = mindLayer
        param.diary = diary
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            locateConst.constant = keyboardHeight + 30
        }
    }

    @IBAction func touchLocation(_ sender: Any) {
    
        if CLLocationManager.locationServicesEnabled() &&
            CLLocationManager.authorizationStatus() != .notDetermined &&
            CLLocationManager.authorizationStatus() != .restricted &&
            CLLocationManager.authorizationStatus() != .denied {
            
            getAddressString()
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
}
