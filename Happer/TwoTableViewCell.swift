//
//  TwoTableViewCell.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 10..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit

class TwoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var location: UIButton!
    @IBOutlet weak var with: UILabel!
    @IBOutlet weak var time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
