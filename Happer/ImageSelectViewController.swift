//
//  ImageSelectViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 4..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit
import Photos
import Spring
import RealmSwift

class ImageSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    var imageArray = [UIImage]()
    var rawImageArray = [UIImage]()
    var selectionIdx = 0
    var isFilter = true
    
    @IBOutlet weak var FilterButton: SpringButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectionImageView: CameraView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageView = UIImageView()
    
    var diary = Diary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            
        } else {
            
        }
    
    }
    
    func loadPhoto() {
        getPhotos()
        
        DispatchQueue.main.async {
            self.grabPhotos()
            
            var filterImage = UIImage().load(self.diary.cicle_path)
            filterImage = self.resizeImage(image: filterImage, w: self.filterView.frame.size.width)
            
            let filterLayer = CALayer()
            filterLayer.frame = CGRect(x: 0, y: 0,
                                       width: self.filterView.frame.size.width,
                                       height: self.filterView.frame.size.width)
            filterLayer.contents = filterImage.cgImage
            
            self.filterView.layer.addSublayer(filterLayer)
            
            if self.isFilter {
                self.filterView.alpha = 0.25
            } else {
                self.filterView.alpha = 0.0
            }
            
            self.imageView = UIImageView()
            self.imageView.frame = CGRect(x: 0.0,
                                          y: 0.0,
                                          width: self.selectionImageView.frame.size.width,
                                          
                                          height: self.selectionImageView.frame.size.width)
            self.imageView.contentMode = .scaleAspectFill
            
            if self.rawImageArray.count != 0 {
                self.imageView.image = self.rawImageArray[self.selectionIdx]
            }
            
            self.scrollView.addSubview(self.imageView)
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            
            loadPhoto()
            
        } else {
            PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus) -> Void in
                if status == .restricted || status == .authorized {
                    self.loadPhoto()
                }
            })
        }
    }
    
    @IBAction func touchClose(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    func getPhotos() {
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            if fetchResult.count > 0 {
                
                var count = fetchResult.count
                
                if count > 30 {
                    count = 30
                }
                
                for i in 0..<count {
                    imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width:200, height:200), contentMode: .aspectFit, options: requestOptions, resultHandler: { image, error in
                        
                        self.imageArray.append(image!)
                        
                    })
                }
                
                self.collectionView.reloadData()
                
            } else {
                print("You got no photos")
                self.collectionView.reloadData()
            }
        }

    }
    
    @IBAction func touchFilter(_ sender: Any) {
        
        if isFilter {
            
            FilterButton.setImage(UIImage(named: "icFillterOn.png"), for: .normal)
            isFilter = false
            filterView.alpha = 0.0
            
        } else {
            
            FilterButton.setImage(UIImage(named: "icFillterOff.png"), for: .normal)
            isFilter = true
            filterView.alpha = 0.25
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        let image = self.rawImageArray[self.selectionIdx]
        imageView.contentMode = .scaleAspectFill
        imageView.image = image;
        
        var overImage = UIImage().load(diary.cicle_path)
        if self.isFilter {
            overImage = overImage.alpha(0.25)
        } else {
            overImage = overImage.alpha(0.0)
        }
        overImage = self.resizeImage(image: overImage, w: 1000)
        
        let myLayer = CALayer()
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
        
        self.diary.photo_path = "\(self.diary.id)photo.png"
        self.diary.toString()
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(self.diary, update: true)
        }
        
    }
    
    func grabPhotos() {
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            if fetchResult.count > 0 {
                
                var count = fetchResult.count
                
                if count > 30 {
                    count = 30
                }
                
                for i in 0..<count {
                    
                    imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width:700, height:700), contentMode: .aspectFit, options: requestOptions, resultHandler: { image, error in
                        
                        self.rawImageArray.append(image!)
                        
                    })
                }
                
                self.collectionView.reloadData()
                
            } else {
                print("You got no photos")
                self.collectionView.reloadData()
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return imageArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        var imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.image = imageArray[indexPath.row]
        
        if indexPath.row == selectionIdx {
            imageView.image = imageArray[indexPath.row].alpha(0.3)
        } else {
            imageView.image = imageArray[indexPath.row].alpha(1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 4 - 1
        
        return CGSize(width: width, height: width)
    
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectionIdx = indexPath.row
        imageView.image = rawImageArray[selectionIdx]
        
        
        
        self.collectionView.reloadData()
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
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
