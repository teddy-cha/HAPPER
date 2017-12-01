//
//  OneTableViewCell.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 10..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit

class OneTableViewCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UIButton!
    @IBOutlet weak var cellImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
