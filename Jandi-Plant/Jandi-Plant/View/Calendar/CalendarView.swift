//
//  CalendarView.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/7/24.
//

import SwiftUI

import JandiNetwork
import Core

struct CalendarView: View {
    var commits: [Commit]
    var currentMonth: Date
    
    private var weeks: [[Date?]] {
        currentMonth.generateDatesForMonth()
    }
    
    private var selectedTheme: [String] {
        UserDefaults.standard.array(forKey: "selectedTheme") as? [String] ?? []
    }
    
    var body: some View {
        VStack {
            Text(currentMonth.toMonthString())
                .font(.title)
                .padding()
            
            HStack {
                ForEach(0..<7) { index in
                    Text(Calendar(identifier: .gregorian).koreanShortWeekdaySymbols[index])
                        .frame(maxWidth: .infinity)
                        .font(.pretendardM(16))
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 5)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(weeks, id: \.self) { week in
                    ForEach(week.indices, id: \.self) { index in
                        let date = week[index]
                        if let date = date {
                            CalendarDayView(date: date,
                                            level: commitLevel(for: date),
                                            theme: selectedTheme)
                        } else {
                            Color.clear
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
        }
    }
    
    private func commitLevel(for date: Date) -> Commit.Level {
        commits.first { Calendar.current.isDate($0.date, inSameDayAs: date) }?.level ?? .none
    }
}
