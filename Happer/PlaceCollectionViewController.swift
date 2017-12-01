//
//  PlaceCollectionViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 18..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PlaceCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var locations = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return locations.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlaceCollectionViewCell
        
        cell.place.text = "#" + locations[indexPath.row]
        
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sizeOfString = CGSize()
        if let font = UIFont(name: "NanumMyeongjo", size: 16.0) {
            let finalDate = "#" + locations[indexPath.row]
            let fontAttributes = [NSFontAttributeName: font]
            sizeOfString = (finalDate as NSString).size(attributes: fontAttributes)
        }
        
        return CGSize(width: sizeOfString.width + 20, height: 32)
    }

}
