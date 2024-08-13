//
//  Calendar+Extension.swift
//
//
//  Created by MEGA_Mac on 8/12/24.
//

import Foundation

extension Calendar {
   public var koreanShortWeekdaySymbols: [String] {
        var calendar = self
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar.shortWeekdaySymbols
    }
}
