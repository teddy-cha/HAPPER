//
//  EditCameraViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 23..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import RealmSwift
import Spring

class EditCameraViewController: UIViewController {
    
    @IBOutlet weak var camera_view: CameraView!
    @IBOutlet weak var FilterButton: SpringButton!
    
    var captureSession = AVCaptureSession()
    var stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var resultLayer = CALayer()
    var cameraStatus = false;
    
    var diary = Diary()

    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    var isFilter = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraGesture = UITapGestureRecognizer(target: self, action: #selector(touchCamera(gesture:)))
        
        camera_view.addGestureRecognizer(cameraGesture)
        
    }

    @IBAction func touchFilter(_ sender: Any) {
        
        if isFilter {
            
            FilterButton.setImage(UIImage(named: "icFillterOn.png"), for: .normal)
            isFilter = false
            
        } else {
            
            FilterButton.setImage(UIImage(named: "icFillterOff.png"), for: .normal)
            isFilter = true
            
        }
        
        reloadCamera()
    }
    
    @IBAction func touchDismiss(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchCamera(gesture: UITapGestureRecognizer) {
        
        // 필터 기능 온 오프
        if isFilter {
            isFilter = false
        } else {
            isFilter = true
        }
        
        reloadCamera()
        
    }
    
    @IBAction func changeCamera(_ sender: Any) {
        
        if cameraStatus == false {
            
            cameraStatus = true
            reloadCamera()
            
            
        } else {
            
            cameraStatus = false
            reloadCamera()
        }
    }
    
    @IBAction func touchAlbum(_ sender: Any) {
        performSegue(withIdentifier: "goAlbum", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkCamera()
    }
    
    func checkCamera(){
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized {
            
            reloadCamera()
            
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
                
                if granted {
                    
                    self.beginSession()
                    
                } else {
                    // User Rejected
                }
            })
        }
        
        
    }
    
    func reloadCamera() {
        
        beginSession()
    }
    
    /**
     이 부분 정리하기!!!!!!!!!!
     */
    
    @IBAction func actionCameraCapture(_ sender: AnyObject) {
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                if let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: CMSampleBuffer!, previewPhotoSampleBuffer: CMSampleBuffer) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        
                        self.captureSession.stopRunning()
                        
                        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
                        let image = cameraImage
                        imageView.contentMode = .scaleAspectFill
                        imageView.image = image;
                        
                        var overImage = UIImage().load(self.diary.cicle_path)
                        if self.isFilter {
                            overImage = overImage.alpha(0.25)
                        } else {
                            overImage = overImage.alpha(0.0)
                        }
                        overImage = self.resizeImage(image: overImage, w: 1000)
                        
                        let myLayer = CALayer()
                        myLayer.frame = self.camera_view.frame
                        myLayer.frame = CGRect(x: -10, y: -10, width: 1020 , height: 1020)
                        myLayer.contents = overImage.cgImage
                        
                        imageView.layer.addSublayer(myLayer)
                        
                        let resultView = UIView()
                        resultView.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
                        resultView.clipsToBounds = true
                        resultView.layer.cornerRadius = 500
                        resultView.layer.addSublayer(imageView.layer)
                        resultView.layer.addSublayer(myLayer)
                        resultView.backgroundColor = UIColor.clear
                        
                        let result = UIImage(layer: resultView.layer, view: resultView)
                        result.save("\(self.diary.id)photo.png")
                        
                        let realm = try! Realm()
                        
                        try! realm.write {
                            self.diary.photo_path = "\(self.diary.id)photo.png"
                        }
                    }
                    self.performSegue(withIdentifier: "goDaily", sender: self)
                    
                    
                }
            })
        }
        
        //        print("Camera button pressed")
        //        saveToCamera()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let param = segue.destination as! EditPhotoViewController
            
            param.diary = diary
    }
    
    func beginSession() {
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
        captureDevice = (cameraStatus ? getFrontCamera() : getBackCamera())
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        for i : AVCaptureDeviceInput in (self.captureSession.inputs as! [AVCaptureDeviceInput]){
            self.captureSession.removeInput(i)
        }
        
        if error == nil && captureSession.canAddInput(input) {
            captureSession.addInput(input)
            stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            print("**********")
            
            let rootLayer :CALayer = self.camera_view.layer
            rootLayer.masksToBounds = true
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                previewLayer?.frame = CGRect(x: 0, y: 0, width: self.camera_view.frame.size.width, height: self.camera_view.frame.size.width)
                
                rootLayer.addSublayer(previewLayer!)
                
                resultLayer.frame = CGRect(x: 0, y: 0, width: self.camera_view.frame.size.width, height: self.camera_view.frame.size.width)
                
                DispatchQueue.main.async {
                    self.captureSession.startRunning()
                }
            }
            
            if isFilter == true {
                rootLayer.sublayers?[(rootLayer.sublayers?.count)! - 1].removeFromSuperlayer()
                var image = UIImage().load(diary.cicle_path)
                image = image.alpha(0.25)
                image = resizeImage(image: image, w: self.camera_view.frame.size.width)
                let myLayer = CALayer()
                myLayer.frame = self.camera_view.frame
                myLayer.frame = CGRect(x: -10, y: -10, width: self.camera_view.frame.size.width + 20 , height: self.camera_view.frame.size.width + 20)
                myLayer.contents = image.cgImage
                rootLayer.addSublayer(myLayer)
            } else {
                rootLayer.sublayers?[(rootLayer.sublayers?.count)! - 1].removeFromSuperlayer()
                var image = UIImage().load(diary.cicle_path)
                image = image.alpha(0.0)
                image = resizeImage(image: image, w: self.camera_view.frame.size.width)
                let myLayer = CALayer()
                myLayer.frame = self.camera_view.frame
                myLayer.frame = CGRect(x: -10, y: -10, width: self.camera_view.frame.size.width + 20 , height: self.camera_view.frame.size.width + 20)
                myLayer.contents = image.cgImage
                rootLayer.addSublayer(myLayer)
            }
        }
    }
    
    func getFrontCamera() -> AVCaptureDevice?{
        let videoDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        
        
        for device in videoDevices!{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevicePosition.front {
                return device
            }
        }
        return nil
    }
    
    func getBackCamera() -> AVCaptureDevice{
        return AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    }
    
    //    func saveToCamera() {
    //
    //        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
    //
    //            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
    //                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
    //
    //                    if let cameraImage = UIImage(data: imageData) {
    //
    //                        UIImageWriteToSavedPhotosAlbum(cameraImage, nil, nil, nil)
    //                    }
    //                }
    //            })
    //        }
    //    }
    
    func resizeImage(image: UIImage, w: CGFloat) -> UIImage {
        
        let scale = w / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: w, height: newHeight))
        image.draw(in: CGRect(x:0, y:0, width:w, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }


}
