//
//  NameCollectionViewCell.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 17..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit

class NameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let toReturn = super.preferredLayoutAttributesFitting(layoutAttributes)
        return toReturn
    }
}
