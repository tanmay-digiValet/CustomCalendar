//
//  DateGridView.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 07/02/25.
//

import SwiftUI
import DVFoundation
import DVThemeKit

struct DateGridView: View {
    
    @Binding var selectedDate: Date?
    @Binding var range: ClosedRange<Date>?
    @Binding var mode: Mode
    @Binding var scrollViewPosition: Date?
    @State private var hasScrolled = false
    
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let calendar = Calendar.current
    private let daysOfWeek = Calendar.current.shortWeekdaySymbols.map { $0.uppercased() }
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top) {
                    ForEach(generateDateArray(from: calendarViewModel.permissibleRange), id: \.self) { date in
                        LazyVGrid(columns: cols, spacing: UIConstants.dateGridSpacing) {
                            Group {
                                ForEach(daysOfWeek, id: \.self) { day in
                                    Text(day)
                                        .fontStyle(.captionCaption1Caps)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 28)
                                        .animation(nil, value: calendarViewModel.helperDate)
                                }
                                
                                ForEach(1...7, id: \.self) { ind in
                                    if ind < date.monthStart.weekday {
                                        Text(" ")
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                
                                switch mode {
                                case .single:
                                    ForEach(1...(date.numberOfDaysInMonth ?? 1), id: \.self) { curr in
                                        let currDate = date.createDate(year: date.year, month: date.month, day: curr) ?? Date.now
                                        let isSelectedDate = calendarViewModel.isSelectedDate(currDate)
                                        let isCurrDateToday = currDate.beginning(of: .day) == Date.now.beginning(of: .day)
                                        let selectedDateCol = isSelectedDate ? UIConstants.selectedDateCol
                                        : UIConstants.defaultDateCol
                                        
                                        Text("\(curr)")
                                            .fontStyle((isCurrDateToday || isSelectedDate) ? .headlineH4Medium : .headlineH4)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: UIConstants.cellHeight)
                                            .background(isSelectedDate ? UIConstants.selectedCellBgCol : UIConstants.bgCol)
                                            .foregroundStyle(isCurrDateToday ? UIConstants.todayDateCol : selectedDateCol)
                                            .opacity(calendarViewModel.isDateDisabled(currDate) ? 0.2 : 1)
                                            .clipShape(Circle())
                                            .onTapGesture {
                                                calendarViewModel.singleModeTap(date: currDate)
                                            }
                                    }
                                    
                                case .range:
                                    ForEach(1...(date.numberOfDaysInMonth ?? 1), id: \.self) { curr in
                                        let currDate = Date.now.createDate(year: date.year, month: date.month, day: curr) ?? Date.now
                                        let isDateDisabledVal = calendarViewModel.isDateDisabled(currDate)
                                        let isSelectedForRange = calendarViewModel.isSelectedDateForRange(currDate)
                                        let isNextDayDisabled = calendarViewModel.isDateDisabled(Calendar.current.date(byAdding: .day, value: 1, to: currDate) ?? Date.now)
                                        let isPrevDayDisabled = calendarViewModel.isDateDisabled(Calendar.current.date(byAdding: .day, value: -1, to: currDate) ?? Date.now)
                                        let isWithinRangeVal = calendarViewModel.isWithinRange(currDate) && !isDateDisabledVal
                                        let isCurrDateToday = currDate.beginning(of: .day) == Date.now.beginning(of: .day)
                                        let selectedDateCol = isSelectedForRange ? UIConstants.selectedDateCol : UIConstants.defaultDateCol
                                        
                                        Text("\(curr)")
                                            .fontStyle(isCurrDateToday || isSelectedForRange ? .headlineH4Medium : .headlineH4)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: UIConstants.cellHeight)
                                            .background(isSelectedForRange ? UIConstants.selectedCellBgCol : UIConstants.bgCol)
                                            .foregroundStyle(isCurrDateToday ? UIConstants.todayDateCol : selectedDateCol)
                                            .opacity(isDateDisabledVal ? 0.2 : 1)
                                            .clipShape(Circle())
                                            .overlay {
                                                if let selectedDate1 = calendarViewModel.selectedDate1, let selectedDate2 = calendarViewModel.selectedDate2 {
                                                    if isWithinRangeVal {
                                                        if isPrevDayDisabled || isNextDayDisabled {
                                                            Text("\(curr)")
                                                                .fontStyle(isCurrDateToday || isSelectedForRange ? .headlineH4Medium : .headlineH4)
                                                                .foregroundStyle(isCurrDateToday ? UIConstants.todayDateCol : selectedDateCol)
                                                                .frame(maxWidth: .infinity)
                                                                .frame(height: UIConstants.cellHeight)
                                                                .background(UIConstants.rangeSelectBgColor)
                                                                .roundedCorner(22, corners:
                                                                                (isPrevDayDisabled && isNextDayDisabled ? [.bottomLeft, .topLeft, .bottomRight, .topRight] :
                                                                                    (isNextDayDisabled ? [.bottomRight, .topRight] :
                                                                                        [.topLeft, .bottomLeft])
                                                                                ))
                                                        } else {
                                                            Text("\(curr)")
                                                                .fontStyle(isCurrDateToday ? .headlineH4Medium : .headlineH4)
                                                                .foregroundStyle(isCurrDateToday ? UIConstants.todayDateCol : selectedDateCol)
                                                                .frame(maxWidth: .infinity)
                                                                .frame(height: UIConstants.cellHeight)
                                                                .background(UIConstants.rangeSelectBgColor)
                                                        }
                                                    } else if (currDate == selectedDate1 || currDate == selectedDate2) {
                                                        ZStack {
                                                            HStack{
                                                                if currDate == selectedDate1 {
                                                                    Color.colorBrandPrimary
                                                                        .frame(maxWidth: .infinity)
                                                                        .frame(height: UIConstants.cellHeight)
                                                                    if !isNextDayDisabled {
                                                                        UIConstants.rangeSelectBgColor
                                                                            .frame(maxWidth: .infinity)
                                                                            .frame(height: UIConstants.cellHeight)
                                                                    }
                                                                } else {
                                                                    if !isPrevDayDisabled {
                                                                        UIConstants.rangeSelectBgColor
                                                                            .frame(maxWidth: .infinity)
                                                                            .frame(height: UIConstants.cellHeight)
                                                                    }
                                                                    Color.colorBrandPrimary
                                                                        .frame(maxWidth: .infinity)
                                                                        .frame(height: UIConstants.cellHeight)
                                                                }
                                                            }
                                                            Text("\(curr)")
                                                                .fontStyle(.headlineH4Medium)
                                                                .frame(width: 44, height: UIConstants.cellHeight)
                                                                .background(UIConstants.selectedCellBgCol)
                                                                .clipShape(Circle())
                                                                .foregroundStyle(isCurrDateToday ? UIConstants.todayDateCol : selectedDateCol)
                                                                .onTapGesture {
                                                                    calendarViewModel.rangeModeTap(date: currDate)
                                                                }
                                                        }
                                                    }
                                                }
                                            }
                                            .animation(.easeInOut(duration: 0.2), value: calendarViewModel.selectedDate)
                                            .onTapGesture {
                                                calendarViewModel.rangeModeTap(date: currDate)
                                            }
                                    }
                                }
                            }
                        }
                        .containerRelativeFrame(.horizontal)
                        .id(date)
                        .onChange(of: calendarViewModel.selectedDate) {
                            selectedDate = calendarViewModel.selectedDate
                        }
                        .onChange(of: calendarViewModel.helperDate) { _, newValue in
                            withAnimation {
                                scrollViewPosition = newValue
                            }
                        }
                        .onChange(of: calendarViewModel.range) {
                            range = calendarViewModel.range
                        }
                    }
                }
                .scrollTargetLayout()
                .onAppear {
                    if !hasScrolled {
                            scrollViewPosition = Date.now.monthStart
                            hasScrolled = true
                    }
                }
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollViewPosition, anchor: .center)
            .onChange(of: scrollViewPosition) {
                if let scrollViewPosition = scrollViewPosition {
                    calendarViewModel.syncMonthYear(scrollViewPosition)
                    print("***", calendarViewModel.helperDate.dateString())
                }
            }
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
        
        var currentDate = range.lowerBound.monthStart
//        currentDate = currentDate.monthStart
        
        while currentDate <= range.upperBound {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? Date.now
            currentDate = currentDate.monthStart
        }
        return dates
    }
}









