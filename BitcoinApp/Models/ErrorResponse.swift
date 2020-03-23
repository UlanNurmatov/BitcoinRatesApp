//
//  ErrorResponse.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/16/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import Foundation

public struct ErrorResponse: Decodable {
    
    var statusCode: Int?
    var message: String?
    var error: String?
}
