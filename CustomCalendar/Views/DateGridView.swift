//
//  DateGridView.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 07/02/25.
//

import SwiftUI
import DVFoundation

struct DateGridView: View {
    
    @Binding var selectedDate: Date?
    @Binding var range: ClosedRange<Date>?
    @Binding var mode: Mode
    @Binding var selectedDate1: Date?
    @Binding var selectedDate2: Date?
    @Binding var scrollViewPosition: Date?
    
    @Binding var isMonthYearPickerOpen: Bool
    
    private let cols = Array(repeating: GridItem(.flexible()), count: 7)
    private let calendar = Calendar.current
    private let daysOfWeek = Calendar.current.shortWeekdaySymbols.map { $0.uppercased() }
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top) {
                ForEach(generateDateArray(from: calendarViewModel.permissibleRange), id: \.self) { date in
                    LazyVGrid(columns: cols, spacing: 20) {
                        
                        Group {
                            ForEach(daysOfWeek, id: \.self) { day in
                                Text(day)
                                    .font(.caption)
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                    .frame(width: 44)
                                    .animation(nil, value: calendarViewModel.helperDate)
                            }
                            
                            ForEach(1...7, id: \.self) { ind in
                                if ind < date.monthStart.weekday {
                                    Text(" ")
                                        .frame(width: 44, height: 44)
                                }
                            }
                            
                            switch mode {
                            case .single:
                                ForEach(1...(date.numberOfDaysInMonth ?? 1), id: \.self) { curr in
                                    let currDate = date.createDate(year: date.year, month: date.month, day: curr) ?? Date.now
                                    Text("\(curr)")
                                        .font(.system(size: 20))
                                        .frame(width: 44, height: 44)
                                        .background(calendarViewModel.isSelectedDate(currDate) ? .black : .white)
                                        .foregroundStyle(calendarViewModel.isSelectedDate(currDate) ? .white : .black)
                                        .opacity(calendarViewModel.isDateDisabled(currDate) ? 0.2 : 1)
                                        .clipShape(Circle())
                                    //                            .animation(.easeInOut(duration: 0.2), value: calendarViewModelObserver.selectedDate)
                                        .onTapGesture {
                                            calendarViewModel.singleModeTap(date: currDate)
                                            isMonthYearPickerOpen = false
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
                                    
                                    Text("\(curr)")
                                        .font(.system(size: 20))
                                        .frame(width: 44, height: 44)
                                        .background(isSelectedForRange ? .black : .white)
                                        .foregroundStyle(isSelectedForRange ? .white : .black)
                                        .opacity(isDateDisabledVal ? 0.2 : 1)
                                        .clipShape(Circle())
                                        .overlay {
                                            if let selectedDate1 = calendarViewModel.selectedDate1, let selectedDate2 = calendarViewModel.selectedDate2 {
                                                if isWithinRangeVal {
                                                    if isPrevDayDisabled || isNextDayDisabled {
                                                        Text("\(curr)")
                                                            .font(.system(size: 20))
                                                            .foregroundStyle(.black)
                                                            .frame(width: 54, height: 44)
                                                            .background(Color(red: 198/255, green: 197/255, blue: 196/255))
                                                            .roundedCorner(15, corners:
                                                                            (isPrevDayDisabled && isNextDayDisabled ? [.bottomLeft, .topLeft, .bottomRight, .topRight] :
                                                                                (isNextDayDisabled ? [.bottomRight, .topRight] :
                                                                                    [.topLeft, .bottomLeft])
                                                                            ))
                                                    } else {
                                                        Text("\(curr)")
                                                            .font(.system(size: 20))
                                                            .foregroundStyle(.black)
                                                            .frame(width: 54, height: 44)
                                                            .background(Color(red: 198/255, green: 197/255, blue: 196/255))
                                                    }
                                                } else if (currDate == selectedDate1 || currDate == selectedDate2) {
                                                    Color(red: 198/255, green: 197/255, blue: 196/255)
                                                        .frame(width: 34, height: 44)
                                                        .offset(x: (currDate == selectedDate1 ? 10 : -10))
                                                        .overlay {
                                                            Text("\(curr)")
                                                                .font(.system(size: 20))
                                                                .frame(width: 44, height: 44)
                                                                .background(.black)
                                                                .foregroundStyle(.white)
                                                                .clipShape(Circle())
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
                                            isMonthYearPickerOpen = false
                                        }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
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
        }
        .scrollTargetBehavior(.viewAligned)
//        .scrollTargetBehavior(.paging)
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









