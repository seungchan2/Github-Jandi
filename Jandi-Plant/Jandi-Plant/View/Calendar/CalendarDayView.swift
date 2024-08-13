//
//  CalendarDayView.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/7/24.
//

import SwiftUI

import Core
import JandiNetwork

struct CalendarDayView: View {
    var date: Date?
    var level: Commit.Level
    var theme: [String]
    var body: some View {
        VStack {
            if let date {
                VStack {
                    Text("\(Calendar.current.component(.day, from: date))")
                        .cornerRadius(4)
                        .font(.pretendardR(13))
                    if let imageName = setImage(for: level) {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .cornerRadius(4)
                    } else {
                        Color.clear.frame(width: 40, height: 40)
                    }
                }
            } else {
                emptyView
            }
        }
    }
    
    
    
    var emptyView: some View {
        VStack {
            Text("")
                .frame(width: 40, height: 10)
            Spacer()
                .frame(width: 40, height: 40)
        }
    }
    
    private func setImage(for level: Commit.Level) -> String? {
        guard level != .none else { return nil }
        
        if level.rawValue < theme.count {
            return theme[level.rawValue]
        } else {
            switch level {
            case .low:
                return "smileL"
            case .medium:
                return "smileM"
            case .high:
                return "smileH"
            case .veryHigh:
                return "smileVH"
            default:
                return nil
            }
        }
    }
}
