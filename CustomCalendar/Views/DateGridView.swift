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
    @Binding var scrollViewPosition: Date?
    
    @Binding var isMonthYearPickerOpen: Bool
    
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let calendar = Calendar.current
    private let daysOfWeek = Calendar.current.shortWeekdaySymbols.map { $0.uppercased() }
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top) {
                    ForEach(generateDateArray(from: calendarViewModel.permissibleRange), id: \.self) { date in
                        LazyVGrid(columns: cols, spacing: UIConstants.dateGridSpacing) {
                            
                            Group {
                                ForEach(daysOfWeek, id: \.self) { day in
                                    Text(day)
                                        .font(.caption)
                                        .font(.system(size: UIConstants.dayFontSize))
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity)
                                        .animation(nil, value: calendarViewModel.helperDate)
                                        .padding(.vertical, UIConstants.cellVerticalPadding)
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
                                        Text("\(curr)")
                                            .font(.system(size: UIConstants.dateFontSize, weight: .medium))
//                                            .frame(height: UIConstants.cellHeight)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, UIConstants.cellVerticalPadding)
                                            .background(isSelectedDate ? .black : .white)
                                            .foregroundStyle(isSelectedDate ? .white : .black)
                                            .fontWeight(isSelectedDate ? .semibold : .regular)
                                            .opacity(calendarViewModel.isDateDisabled(currDate) ? 0.2 : 1)
                                            .clipShape(Circle())
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
                                            .font(.system(size: UIConstants.dateFontSize))
//                                            .frame(height: UIConstants.cellHeight)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, UIConstants.cellVerticalPadding)
                                            .background(isSelectedForRange ? .black : .white)
                                            .foregroundStyle(isSelectedForRange ? .white : .black)
                                            .fontWeight(isSelectedForRange ? .semibold : .regular)
                                            .opacity(isDateDisabledVal ? 0.2 : 1)
                                            .clipShape(Circle())
                                            .overlay {
                                                if let selectedDate1 = calendarViewModel.selectedDate1, let selectedDate2 = calendarViewModel.selectedDate2 {
                                                    if isWithinRangeVal {
                                                        if isPrevDayDisabled || isNextDayDisabled {
                                                            Text("\(curr)")
                                                                .font(.system(size: UIConstants.dateFontSize, weight: .regular))
                                                                .foregroundStyle(.black)
//                                                                .frame(height: UIConstants.cellHeight)
                                                                .frame(maxWidth: .infinity)
                                                                .padding(.vertical, UIConstants.cellVerticalPadding)
                                                                .background(UIConstants.rangeSelectBgColor)
                                                                .roundedCorner(15, corners:
                                                                                (isPrevDayDisabled && isNextDayDisabled ? [.bottomLeft, .topLeft, .bottomRight, .topRight] :
                                                                                    (isNextDayDisabled ? [.bottomRight, .topRight] :
                                                                                        [.topLeft, .bottomLeft])
                                                                                ))
                                                                
                                                        } else {
                                                            Text("\(curr)")
                                                                .font(.system(size: UIConstants.dateFontSize))
                                                                .foregroundStyle(.black)
//                                                                .frame(height: UIConstants.cellHeight)
                                                                .frame(maxWidth: .infinity)
                                                                .padding(.vertical, UIConstants.cellVerticalPadding)
                                                                .background(UIConstants.rangeSelectBgColor)
                                                        }
                                                    } else if (currDate == selectedDate1 || currDate == selectedDate2) {
                                                        
                                                        Text("\(curr)")
//                                                            .frame(height: UIConstants.cellHeight)
                                                            .frame(maxWidth: .infinity)
                                                            .padding(.vertical, UIConstants.cellVerticalPadding)
                                                            .background(UIConstants.rangeSelectBgColor)
                                                            .overlay {
                                                                ZStack {
                                                                    HStack{
                                                                        if currDate == selectedDate1 {
                                                                            Color.white
                                                                                .frame(maxWidth: .infinity)
                                                                            if !isNextDayDisabled {
                                                                                UIConstants.rangeSelectBgColor
                                                                                    .frame(maxWidth: .infinity)
                                                                            }
                                                                        } else {
                                                                            if !isPrevDayDisabled {
                                                                                UIConstants.rangeSelectBgColor
                                                                                    .frame(maxWidth: .infinity)
                                                                            }
                                                                            Color.white
                                                                                .frame(maxWidth: .infinity)
                                                                        }
                                                                        
                                                                    }
                                                                    Text("\(curr)")
                                                                        .font(.system(size: UIConstants.dateFontSize, weight: .semibold))
//                                                                        .frame(width: UIConstants.selectedCircleWidth, height: UIConstants.selectedCircleWidth)
                                                                        .frame(width: UIConstants.selectedCircleWidth)
                                                                        .padding(.vertical, UIConstants.cellVerticalPadding)
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
                        .frame(width: geometry.size.width)
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









