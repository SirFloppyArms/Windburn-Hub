//
//  CalendarGridView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    var items: [CalendarItem]

    @State private var currentMonth = Date()
    let calendar = Calendar.current
    let today = Date()
    
    var calendarHeight: CGFloat {
        let rows = (generateDays(for: currentMonth).count / 7)
        return CGFloat(120 + (rows * 36)) // header + rows
    }

    var body: some View {
        VStack(spacing: 6) {
            // Month nav
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }

                Spacer()

                Text(currentMonth.formatted(.dateTime.month(.wide).year()))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(WindburnColors.primary)

                Spacer()

                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)

            // Weekdays
            HStack(spacing: 0) {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }

            // Days
            let days = generateDays(for: currentMonth)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 4) {
                ForEach(days, id: \.self) { date in
                    if let date = date {
                        let isToday = calendar.isDate(date, inSameDayAs: today)
                        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                        let hasEvent = items.contains { calendar.isDate($0.date, inSameDayAs: date) }

                        VStack(spacing: 2) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(
                                    isSelected ? .white :
                                    isToday ? WindburnColors.primary :
                                    .gray
                                )
                                .frame(width: 24, height: 24)
                                .background(
                                    Circle()
                                        .fill(isSelected ? WindburnColors.secondary : .clear)
                                )
                                .onTapGesture {
                                    selectedDate = date
                                }

                            if hasEvent {
                                Circle()
                                    .fill(WindburnColors.primary)
                                    .frame(width: 4, height: 4)
                            } else {
                                Spacer().frame(height: 4)
                            }
                        }
                        .frame(height: 36)
                    } else {
                        Color.clear.frame(height: 36)
                    }
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(WindburnColors.cardDark)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        )
        .onAppear {
            currentMonth = selectedDate
        }
    }

    private func changeMonth(by offset: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: offset, to: currentMonth) else { return }
        currentMonth = newMonth
        selectedDate = newMonth.startOfMonth
    }

    private func generateDays(for month: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: month))
        else { return [] }

        let offset = calendar.component(.weekday, from: firstDay) - 1
        var days: [Date?] = Array(repeating: nil, count: offset)

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        return days
    }
}
