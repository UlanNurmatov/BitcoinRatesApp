//
//  BitcoinCurrentPrice.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/19/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import Foundation

public struct BitcoinCurrentPrice: Decodable {
    
    var bpi: BPI
}

struct BPI: Decodable {
    
    var USD: RateInfo
    var EUR: RateInfo?
    var KZT: RateInfo?
}

struct RateInfo: Decodable {
    
    var code: String
    var rate: String
    var description: String
    var rate_float: Double
    
}
