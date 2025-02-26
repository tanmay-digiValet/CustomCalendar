//
//  ContentView.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 07/02/25.
//

import SwiftUI

enum Weekday: Int, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

struct ContentView: View {
    var permissibleRange: ClosedRange<Date>? = nil
//    (Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 28)) ?? Date.now)...(Calendar.current.date(from: DateComponents(year: 2035, month: 12, day: 28)) ?? Date.now)
    
    @State var range: ClosedRange<Date>? = nil
    @State var selectedDate: Date? = nil
    @State var mode: Mode = .range
    @State var startTime = Date()
    @State var endTime = Date()
    
    var disabledDays: [Weekday] = [.wednesday]
    var disabledDates: [Date] = [
        (Date.now.createDate(year: 2025, month: 9, day: 11) ?? Date.now),
        (Date.now.createDate(year: 2025, month: 9, day: 12) ?? Date.now),
        (Date.now.createDate(year: 2025, month: 9, day: 19) ?? Date.now),
        (Date.now.createDate(year: 2025, month: 10, day: 20) ?? Date.now),
        (Date.now.createDate(year: 2025, month: 11, day: 18) ?? Date.now),
        (Date.now.createDate(year: 2025, month: 12, day: 14) ?? Date.now),
        (Date.now.createDate(year: 2025, month: 2, day: 10) ?? Date.now),
        (Date.now.createDate(year: 2025, month: 3, day: 19) ?? Date.now),
        (Date.now.createDate(year: 2025, month: 5, day: 19) ?? Date.now),
        (Date.now.createDate(year: 2025, month: 8, day: 19) ?? Date.now)
    ]
    
    var body: some View {
        VStack {
            CalendarMainView(
                range: $range,
                selectedDate: $selectedDate,
                permissibleRange: permissibleRange,
                disabledDays: disabledDays,
                disabledDates: disabledDates,
                mode: $mode,
                startTime: $startTime,
                endTime: $endTime
            )
        }
        .onChange(of: range) { _, newValue in
            print("lowerBound: ",  newValue?.lowerBound.dateString() ?? "")
            print("upperBound: ",  newValue?.upperBound.dateString() ?? "")
        }
        .onChange(of: selectedDate) { _, newValue in
            print("Selected Date: ", newValue?.dateString() ?? "")
        }
        .onChange(of: startTime) {
            print("startTime: ", startTime.timeString(ofStyle: .short))
            print("endTime: ", endTime.timeString(ofStyle: .short))
        }
        .onChange(of: endTime) {
            print("startTime: ", startTime.timeString(ofStyle: .short))
            print("endTime: ", endTime.timeString(ofStyle: .short))
        }
    }
}

#Preview {
    ContentView()
}
