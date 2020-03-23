//
//  TransactionDetailsViewController.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/23/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import UIKit

class TransactionDetailsViewController: UIViewController {
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var id: UILabel!

    var transaction: Transaction!
    
    func getStringDate(date: String) -> String {
        
        let time = Double(transaction.date)
        let date = Date(timeIntervalSince1970: TimeInterval(time!))
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL dd, HH:mm"
        return formatter.string(from: date)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Transaction"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        amount.text = transaction.amount
        date.text = getStringDate(date: transaction.date)
        type.text = transaction.type == "0" ? "Bought" : "Sold"
        price.text = transaction.price
        id.text = transaction.tid
    }
    

    
}
