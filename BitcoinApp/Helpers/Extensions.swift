//
//  Extensions.swift
//  BitcoinApp
//
//  Created by Ulan Nurmatov on 3/19/20.
//  Copyright © 2020 Ulan Nurmatov. All rights reserved.
//

import Foundation

extension PricesViewController {
    
    func getStartandEndDates(period: Period) -> [String] {
        let now = Date()
        let calendar = Calendar.current.dateComponents(in: .current, from: now)
        let startComp: DateComponents
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if period == .year {
            startComp = DateComponents(year: calendar.year! - 1, month: calendar.month, day: 1)
            let startDate = dateFormatter.string(from: Calendar.current.date(from: startComp)!)
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let endComp = DateComponents(year: calendar.year, month: calendar.month, day: 1)

            let endDate = dateFormatter.string(from: Calendar.current.date(from: endComp)!)

            return [startDate, endDate]
        } else {
            startComp = DateComponents(year: calendar.year, month: calendar.month, day: calendar.day! - period.rawValue)
            let startDate = dateFormatter.string(from: Calendar.current.date(from: startComp)!)
            let endDate = dateFormatter.string(from: now)
            return [startDate, endDate]
        }
        
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

