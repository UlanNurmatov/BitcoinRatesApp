//
//  BitcoinPrice.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/16/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import Foundation

public struct BitcoinHistoricalPrice: Decodable {
    
    public var bpi: [String: Double]
}
