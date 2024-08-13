//
//  Date+Extension.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/7/24.
//

import Foundation

// MARK: - Date Extension
extension Date {
    static let calendar = Calendar.current
    
    public func toYearString() -> String {
        let yearFormatter = DateFormatter()
        yearFormatter.locale = Locale(identifier: "ko_KR")
        yearFormatter.dateFormat = "yyyy"
        return yearFormatter.string(from: self)
    }
    
    public func toMonthString() -> String {
        let monthFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "ko_KR")
        monthFormatter.dateFormat = "MMMM"
        return monthFormatter.string(from: self)
    }
    
    public func generateDatesForMonth() -> [[Date?]] {
        var dates: [Date?] = []
        
        let startOfMonth = self.startOfMonth()
        let range = Date.calendar.range(of: .day, in: .month, for: startOfMonth)!
        let firstWeekday = Date.calendar.component(.weekday, from: startOfMonth)
        
        dates.append(contentsOf: Array(repeating: nil, count: firstWeekday - 1))
        
        for day in range {
            if let date = Date.calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                dates.append(date)
            }
        }
        
        let remainingDays = 7 - (dates.count % 7)
        if remainingDays < 7 {
            dates.append(contentsOf: Array(repeating: nil, count: remainingDays))
        }
        
        return stride(from: 0, to: dates.count, by: 7).map {
            Array(dates[$0..<min($0 + 7, dates.count)])
        }
    }
    
    public func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
}
