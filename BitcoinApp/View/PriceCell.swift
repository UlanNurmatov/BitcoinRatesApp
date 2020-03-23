//
//  PriceCell.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/16/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import UIKit

class PriceCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
