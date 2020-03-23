//
//  Transactions.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/23/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import Foundation

struct Transaction: Decodable {
    
    var date: String
    var tid: String
    var price: String
    var type: String
    var amount: String
}

