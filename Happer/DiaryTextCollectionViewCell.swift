//
//  DiaryTextCollectionViewCell.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 18..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit

class DiaryTextCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var daily_text: UILabel!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let toReturn = super.preferredLayoutAttributesFitting(layoutAttributes)
        return toReturn
    }
}
