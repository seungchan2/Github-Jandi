//
//  Commit.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/7/24.
//

import Foundation

public struct Commit: Equatable, Hashable {
    
    
    public let date: Date
    public let level: Level
    
    @frozen
    public enum Level: Int, CaseIterable {
        case none = 0
        case low = 1
        case medium = 2
        case high = 3
        case veryHigh = 4
        
        public static var nonNoneCases: [Level] {
            return allCases.filter { $0 != .none }
        }
    }
    
    public init(date: Date, level: Level) {
        self.date = date
        self.level = level
    }
}
