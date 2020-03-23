//
//  TransactionsCell.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/23/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import UIKit

class TransactionsCell: UITableViewCell {
    
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!

    
    var transaction: Transaction! {
        didSet {
            quantity.text = transaction.amount
            date.text = getStringDate(date: transaction.date)
            type.text = transaction.type == "0" ? "Bought" : "Sold"
        
        }
    }
    
    func getStringDate(date: String) -> String {
        let time = Double(transaction.date)
        let date = Date(timeIntervalSince1970: TimeInterval(time!))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, HH:mm"
        return formatter.string(from: date)
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
