//
//  CalendarGridView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    var events: [Event]

    let calendar = Calendar.current
    let today = Date()

    var body: some View {
        let days = generateDays()

        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
            ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                Text(day).bold().frame(maxWidth: .infinity)
            }

            ForEach(days, id: \.self) { date in
                VStack {
                    Text("\(calendar.component(.day, from: date))")
                        .fontWeight(calendar.isDate(date, inSameDayAs: selectedDate) ? .bold : .regular)
                        .foregroundColor(calendar.isDate(date, inSameDayAs: today) ? .blue : .primary)
                        .onTapGesture {
                            selectedDate = date
                        }

                    if events.contains(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 6, height: 6)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 40)
            }
        }
        .padding(.horizontal)
    }

    private func generateDays() -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: selectedDate),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))
        else { return [] }

        let offset = calendar.component(.weekday, from: firstDay) - 1
        var days: [Date] = []

        for i in 0..<(range.count + offset) {
            if i < offset {
                days.append(Date.distantPast)  // Placeholder for empty days
            } else {
                days.append(calendar.date(byAdding: .day, value: i - offset, to: firstDay)!)
            }
        }
        return days
    }
}
