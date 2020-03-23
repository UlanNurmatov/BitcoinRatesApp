//
//  ServerManager.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/16/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import Foundation
import Alamofire

class ServerManager: HTTPRequestManager {
    
    static let shared = ServerManager()

    func getBitcoinPrices(start: String, end: String, currency: String, header: HTTPHeaders, completion: @escaping (BitcoinHistoricalPrice) -> (), error: @escaping (ErrorResponse) -> (), networkError: @escaping (String)->()) {
           
        self.get(endpoint: "https://api.coindesk.com/v1/bpi/\(Constants.Network.EndPoint.historicalRate)start=\(start)&end=\(end)&currency=\(currency)", header: header, completion: { (data) in
               do {
                   guard let  data = data else { return }
                   let result = try JSONDecoder().decode(BitcoinHistoricalPrice.self, from: data)
                completion(result)
               }
               catch let errorMessage {
                   networkError(errorMessage.localizedDescription)
               }
           }, error: { (data) in
               do {
                   guard let data = data else { return }
                   let result = try JSONDecoder().decode(ErrorResponse.self, from: data)
                   error(result)
               }
               catch let errorMessage {
                   networkError(errorMessage.localizedDescription)
               }
           }) { (errorMessage) in
               networkError(errorMessage)
           }
        
       }
    
    func getcurrentPrice(currency: String, header: HTTPHeaders, completion: @escaping (BitcoinCurrentPrice) -> (), error: @escaping (ErrorResponse) -> (), networkError: @escaping (String)->()) {
        
        self.get(endpoint: "https://api.coindesk.com/v1/bpi/\(Constants.Network.EndPoint.currentPrice)\(currency).json", header: header, completion: { (data) in
            do {
                guard let  data = data else { return }
                let result = try JSONDecoder().decode(BitcoinCurrentPrice.self, from: data)
             completion(result)
            }
            catch let errorMessage {
                networkError(errorMessage.localizedDescription)
            }
        }, error: { (data) in
            do {
                guard let data = data else { return }
                let result = try JSONDecoder().decode(ErrorResponse.self, from: data)
                error(result)
            }
            catch let errorMessage {
                networkError(errorMessage.localizedDescription)
            }
        }) { (errorMessage) in
            networkError(errorMessage)
        }
     
    }
    
    func getTransactions(header: HTTPHeaders, completion: @escaping ([Transaction]) -> (), error: @escaping (ErrorResponse) -> (), networkError: @escaping (String)->()) {
        
        self.get(endpoint: Constants.Network.EndPoint.transactions, header: header, completion: { (data) in
            do {
                guard let  data = data else { return }
                let result = try JSONDecoder().decode([Transaction].self, from: data)
             completion(result)
            }
            catch let errorMessage {
                networkError(errorMessage.localizedDescription)
            }
        }, error: { (data) in
            do {
                guard let data = data else { return }
                let result = try JSONDecoder().decode(ErrorResponse.self, from: data)
                error(result)
            }
            catch let errorMessage {
                networkError(errorMessage.localizedDescription)
            }
        }) { (errorMessage) in
            networkError(errorMessage)
        }
     
    }
}
