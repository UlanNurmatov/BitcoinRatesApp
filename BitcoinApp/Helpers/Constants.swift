//
//  Constants.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/16/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Network {
        
        struct EndPoint {
            
            static let historicalRate = "historical/close.json?"
            static let currentPrice = "currentprice/"
            static let transactions = "https://www.bitstamp.net/api/v2/transactions/btcusd/"
            
        }
        
        struct ErrorMessage {
            static let NO_INTERNET_CONNECTION = "No internet connection"
            static let UNABLE_LOAD_DATA = "Check internet connection"
            static let NO_HTTP_STATUS_CODE = "Unable to get response HTTP status code"
            static let UNAUTHORIZED = "Unauthorized error"
        }
    }
}
