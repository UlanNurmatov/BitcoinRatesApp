//
//  BitcoinPriceViewModel.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/18/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import Foundation

struct BitcoinPriceViewModel {
    
    var dates: [String] = []
    var prices: [Double] = []
    
    init(bitcoinPrice: BitcoinHistoricalPrice) {
        
        let sorted = bitcoinPrice.bpi.sorted(by: { $0.0 < $1.0 })
        
        if bitcoinPrice.bpi.count <= 7 {
            let dates = bitcoinPrice.bpi.keys.sorted()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            for element in dates {
                let date = dateFormatter.date(from: element)!
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let formattedDate = dateFormatter.string(from: date)
                self.dates.append(formattedDate)
                dateFormatter.dateFormat = "yyyy-MM-dd"

            }
            for element in sorted {
                self.prices.append(element.value)
            }
        } else if bitcoinPrice.bpi.count <= 31 {
                  var newDict: [String: Double] = [:]
                  var prices: [Double] = []

                  for element in sorted {
                      newDict[element.key] = element.value
                    prices.append(element.value)
                  }
                  var keys: [String] = []
                  keys.append(contentsOf: newDict.keys.sorted())
                  let dateChunks = keys.chunked(into: 7)
                  let priceChunks = prices.chunked(into: 7)
            
                  let dateFormatter = DateFormatter()
                  dateFormatter.dateFormat = "yyyy-MM-dd"
                  for group in dateChunks {
                    if let first = group.first, let last = group.last {
                        let firstDate = dateFormatter.date(from: first)!
                        let lastDate = dateFormatter.date(from: last)!
                        dateFormatter.dateFormat = "MMM dd"
                        let formattedStart = dateFormatter.string(from: firstDate)
                        let formattedLast = dateFormatter.string(from: lastDate)

                        self.dates.append("\(formattedStart) - \(formattedLast)")
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                    }
                  }
            var sum: Double = 0.0
            for group in priceChunks {
                for price in group {
                    sum += price
                }
                let finalAverage = sum / Double(group.count)
                self.prices.append(finalAverage)
                sum = 0.0
            }
        } else {
            
            let dateFormatter = DateFormatter()
            let calendar = Calendar.current
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            var startDate = dateFormatter.date(from: sorted[0].key)!

            var datesArray: [Date] = [startDate]
            var numberOfDaysForMonths: [Int] = []
            var priceValues: [Double] = []
            var pricesPerDayOfEachMonth: [[Double]] = []
            
            //Get all values from sorted array
            for element in sorted {
              priceValues.append(element.value)
            }
            
            //Get Dates of 12 months
            for _ in 1...11 {
                startDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
                datesArray.append(startDate)
                
            }
            
            //Get number of days in each month
            for date in datesArray {
                let range = calendar.range(of: .day, in: .month, for: date)!
                let numDays = range.count
                dateFormatter.dateFormat = "LLLL, yyyy"
                self.dates.append(dateFormatter.string(from: date))
                numberOfDaysForMonths.append(numDays)
            }
            
            for num in numberOfDaysForMonths {
                let pricesInMonth = priceValues[0..<num]
                pricesPerDayOfEachMonth.append(Array(pricesInMonth))
                priceValues.removeSubrange(0..<num)
            }
            
            var sum: Double = 0.0
            for group in pricesPerDayOfEachMonth {
                for price in group {
                    sum += price
                }
                let finalAverage = sum / Double(group.count)
                self.prices.append(finalAverage)
                sum = 0.0
            }
            
            
        }
    }
    
    
    
}
