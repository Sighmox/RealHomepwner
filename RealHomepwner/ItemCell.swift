//
//  ItemCell.swift
//  RealHomepwner
//
//  Created by Paul Baker on 2/26/19.
//  Copyright © 2019 Paul Baker. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        valueLabel.adjustsFontForContentSizeCategory = true
        
    }
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
}
