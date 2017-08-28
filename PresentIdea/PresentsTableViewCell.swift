//
//  PresentsTableViewCell.swift
//  PresentIdea
//
//  Created by Markus Fox on 28.08.17.
//  Copyright © 2017 Markus Fox. All rights reserved.
//

import UIKit

class PresentsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
