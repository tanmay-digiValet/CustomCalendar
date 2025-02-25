//
//  CustomMonthYearPicker.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 25/02/25.
//
import SwiftUI
import DVThemeKit

struct CustomMonthYearPicker: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var selectedMonth: String = "January"
    @State var selectedYear: String = "2025"
    
    var body: some View {
//        Picker(selection: $)
        Text("Hello")
            
    }
    
    func generateDateArray(from range: ClosedRange<Date>?) -> [Date] {
        var dates: [Date] = []
        
        guard let range = range else {
            let lowerBound = Date.now.createDate(year: Date.now.year - 5, month: Date.now.month, day: 1) ?? Date.now
            let upperBound = Date.now.createDate(year: Date.now.year + 5, month: Date.now.month, day: 1) ?? Date.now
            calendarViewModel.permissibleRange = lowerBound...upperBound
            
            var currentDate = lowerBound
            while currentDate <= upperBound {
                dates.append(currentDate)
                currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? Date.now
                currentDate = currentDate.monthStart
            }
            return dates
        }
        
        var currentDate = range.lowerBound
        currentDate = currentDate.monthStart
        
        while currentDate <= range.upperBound {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? Date.now
            currentDate = currentDate.monthStart
        }
        return dates
    }
}
