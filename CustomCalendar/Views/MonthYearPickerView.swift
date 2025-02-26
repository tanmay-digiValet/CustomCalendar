//
//  MonthYearPickerView.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 25/02/25.
//
import SwiftUI
import DVThemeKit

struct MonthYearPickerView: View {
    
    @Binding var pickerSelectedDate: Date
    @Binding var isMonthYearPickerOpen: Bool
    var validRange: ClosedRange<Date>?
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isMonthYearPickerOpen = false
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack {
                DatePicker (
                    "Select Month & Year",
                    selection: Binding(
                        get: { $pickerSelectedDate.wrappedValue },
                        set: { newValue in
                            $pickerSelectedDate.wrappedValue = newValue.monthStart
                        }
                    ),
                    in:
                        (validRange?.lowerBound.monthStart ?? Date.now)...(validRange?.upperBound ?? Date.now),
                    displayedComponents: .date
                )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
            }
            .frame(width: 350, height: 250)
            .background(UIConstants.bgCol)
            .cornerRadius(20)
        }
    }
}
