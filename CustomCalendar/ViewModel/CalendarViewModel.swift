//
//  CalendarViewModel.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 11/02/25.
//
import SwiftUI
import DVFoundation

class CalendarViewModel: ObservableObject {
    @Published var helperDate: Date
    @Published var selectedDate: Date?
    @Published var range: ClosedRange<Date>?
    @Published var selectedDate1: Date? = nil
    @Published var selectedDate2: Date? = nil
    @Published var isLeftChevron: Bool = false
    @Published var isRightChevron: Bool = true
    
    var disabledDays: [Weekday] = []
    var disabledDates: [Date] = []
    var permissibleRange: ClosedRange<Date>? = nil
    private let calendar = Calendar.current
    
    // MARK: Single Mode
    init(
        range: ClosedRange<Date>?,
        selectedDate: Date?,
        permissibleRange: ClosedRange<Date>?,
        helperDate: Date,
        disabledDays: [Weekday],
        disabledDates: [Date]
    ) {
        self.range = range
        self.helperDate = helperDate
        self.selectedDate = selectedDate
        self.permissibleRange = permissibleRange
        self.disabledDays = disabledDays
        self.disabledDates = disabledDates
    }
    
    func singleModeTap(date: Date?) {
        if selectedDate == date {
            selectedDate = nil
        } else if !isDateDisabled(date ?? Date.now) {
            selectedDate = date
        }
    }
    
    func rangeModeTap (date: Date?) {
        if isDateDisabled(date ?? Date.now) {
            return
        }
        if selectedDate1 == date || selectedDate2 == date {
            selectedDate1 = nil
            selectedDate2 = nil
        } else if selectedDate1 == nil {
            selectedDate1 = date
            selectedDate2 = nil
        } else if selectedDate2 == nil {
            if date ?? Date.now < selectedDate1 ?? Date.now {
                selectedDate1 = date
            } else {
                selectedDate2 = date
            }
        } else {
            selectedDate1 = date
            selectedDate2 = nil
        }
        
        var newRange: ClosedRange<Date>? = nil
        if let date1 = selectedDate1, let date2 = selectedDate2 {
            newRange = date1...date2
            range = newRange
        }
    }
    
    func isSelectedDate(_ date: Date?) -> Bool {
        return date == selectedDate
    }
    
    func isSelectedDateForRange(_ date: Date?) -> Bool {
        return date == selectedDate1 || date == selectedDate2
    }
    
    func isDateDisabled(_ date: Date) -> Bool {
        let weekDay = calendar.component(.weekday, from: date)
        return (disabledDays.contains { $0.rawValue == weekDay } ||
                !(permissibleRange?.contains(date) ?? true) ||
                disabledDates.contains(date))
    }
    
    func isWithinRange(_ date: Date) -> Bool {
        guard let unwrappedRange = range else {
            return false
        }
//        return date != unwrappedRange.lowerBound && date != unwrappedRange.upperBound && unwrappedRange ~= date
        return date > unwrappedRange.lowerBound && date < unwrappedRange.upperBound
    }
    
    func syncMonthYear(_ date: Date) {
        if date != helperDate {
            helperDate = date
            chevronCheck()
        }
    }
    
    func lowerBoundCheck() {
        if permissibleRange == nil || permissibleRange?.lowerBound ?? Date.now < helperDate {
            helperDate = Calendar.current.date(byAdding: .month, value: -1, to: helperDate) ?? Date.now
            isRightChevron = true
            if permissibleRange != nil
                && permissibleRange?.lowerBound.month == helperDate.month
                && permissibleRange?.lowerBound.year == helperDate.year {
                isLeftChevron = false
            }
        }
    }
    
    func upperBoundCheck() {
        if permissibleRange == nil || permissibleRange?.upperBound ?? Date.now > helperDate {
            helperDate = Calendar.current.date(byAdding: .month, value: +1, to: helperDate) ?? Date.now
            isLeftChevron = true
            if permissibleRange != nil
                && permissibleRange?.upperBound.month == helperDate.month
                && permissibleRange?.upperBound.year == helperDate.year {
                isRightChevron = false
            }
        }
    }
    
    func chevronCheck() {
        if permissibleRange?.lowerBound.month == helperDate.month
            && permissibleRange?.lowerBound.year == helperDate.year {
            isLeftChevron = false
        } else {
            isLeftChevron = true
        }
        
        if permissibleRange?.upperBound.month == helperDate.month
            && permissibleRange?.upperBound.year == helperDate.year {
            isRightChevron = false
        } else {
            isRightChevron = true
        }
    }
    
}
