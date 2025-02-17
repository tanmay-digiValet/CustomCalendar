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
    var permissibleRange: ClosedRange<Date>? =
    (Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 28)) ?? Date.now)...(Calendar.current.date(from: DateComponents(year: 2035, month: 12, day: 28)) ?? Date.now)
    @State var range: ClosedRange<Date>? = nil
    @State var selectedDate: Date? = nil
    @State var selectedRange: ClosedRange<Date>? = nil
//    @State var mode: Mode = .single
    @State var mode: Mode = .range
    @State var monthSelector = false
    var disabledDays: [Weekday] = [.sunday]
    var disabledDates: [Date] = [
        (Date.now.createDate(year: 2025, month: 9, day: 11) ?? Date.now),
        (Date.now.createDate(year: 2025, month: 9, day: 12) ?? Date.now),
        (Date.now.createDate(year: 2025, month: 9, day: 19) ?? Date.now)
    ]
    
    var body: some View {
        VStack  {
            CalendarMainView(
                range: $range,
                selectedDate: $selectedDate,
                permissibleRange: permissibleRange,
                disabledDays: disabledDays,
                disabledDates: disabledDates,
                mode: $mode
            )
//            Button("Toggle mode") {
//                mode = mode == .range ? .single : .range
//            }
        }
        .onChange(of: range) { _, newValue in
            print("lowerBound: ",  newValue?.lowerBound.dateString() ?? "")
            print("upperBound: ",  newValue?.upperBound.dateString() ?? "")
        }
        .onChange(of: selectedDate) { _, newValue in
            print("Selected Date: ", newValue?.dateString() ?? "")
        }
    }
}

#Preview {
    ContentView()
}
