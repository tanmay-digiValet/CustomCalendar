//
//  CalendarMainView.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 10/02/25.
//

import SwiftUI
import DVThemeKit

struct CalendarMainView: View {
    
    // MARK: Dependencies
    var permissibleRange: ClosedRange<Date>? = nil
    @Binding var range: ClosedRange<Date>?
    @Binding var selectedDate: Date?
    var disabledDays: [Weekday] = []
    var disabledDates: [Date] = []
    @Binding var mode: Mode
    
    // MARK: Local states and variables
    // MARK: initially assigned to first date of lowerBound of permissibleRange (in onAppear),
    // MARK: intended to keep track and enable transition of active month and year.
    @State var helperDate: Date = Date.now.monthStart
    @State var selectedDate1: Date? = nil
    @State var selectedDate2: Date? = nil
    @State var scrollViewPosition: Date? = nil
    @State var isMonthYearPickerOpen: Bool = false
    
    @State var selectedStartTime = Date()
    @State var selectedEndTime = Date()
    @State var isStartTimePickerOpen = false
    @State var isEndTimePickerOpen = false
    
    @StateObject var calendarViewModel: CalendarViewModel
    
    init(
        range: Binding<ClosedRange<Date>?>,
        selectedDate: Binding<Date?>,
        permissibleRange: ClosedRange<Date>?,
        disabledDays: [Weekday],
        disabledDates: [Date],
        mode: Binding<Mode>
    ) {
        
        self._range = range
        self._selectedDate = selectedDate
        self.disabledDays = disabledDays
        self.disabledDates = disabledDates
        self.permissibleRange = permissibleRange
        self._mode = mode
        _calendarViewModel = StateObject(wrappedValue:
                                            CalendarViewModel(
                                                range: range.wrappedValue,
                                                selectedDate: selectedDate.wrappedValue,
                                                permissibleRange: permissibleRange,
                                                helperDate: Date.now.monthStart,
                                                disabledDays: disabledDays,
                                                disabledDates: disabledDates
                                            ))
    }
        
    var body: some View {
        ZStack {
            UIConstants.bgCol
                .ignoresSafeArea()
                
            VStack {
                HStack (spacing: 20) {
                    HStack (spacing: 5) {
                        Text("\(calendarViewModel.helperDate.formatted(.dateTime.month()))")
                            .fontStyle(.headlineH4Medium)
                            .animation(.easeInOut(duration: 0.2), value: calendarViewModel.helperDate.month)
                            .contentTransition(.numericText(value: Double(calendarViewModel.helperDate.month)))
                        
                        Text("\(calendarViewModel.helperDate.formatted(.dateTime.year()))")
                            .fontStyle(.headlineH4Medium)
                            .animation(.easeInOut(duration: 0.2), value: calendarViewModel.helperDate.year)
                            .contentTransition(.numericText(value: Double(calendarViewModel.helperDate.year)))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: UIConstants.chevronFontSize))
                            .foregroundStyle(UIConstants.chevronCol)
                            .frame(width: 24, height: 24)
                            .padding(.leading, -5)
                    }
                    .fontStyle(.headlineH4Medium)
                    .onTapGesture {
                        isMonthYearPickerOpen = true
                    }
                    .animation(.easeInOut, value: calendarViewModel.helperDate)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(
                            action: {
                                withAnimation {
                                    calendarViewModel.lowerBoundCheck()
                                }
                            } ) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: UIConstants.chevronFontSize))
                                .foregroundStyle(UIConstants.chevronCol)
                        }
                            .opacity(calendarViewModel.isLeftChevron ? 1 : 0.25)
                            .frame(width: 24, height: 24)
                            .disabled(!calendarViewModel.isLeftChevron)
                        
                        Button(
                            action: {
                                withAnimation {
                                    calendarViewModel.upperBoundCheck()
                                }
                            }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: UIConstants.chevronFontSize))
                                .foregroundStyle(UIConstants.chevronCol)
                        }
                            .opacity(calendarViewModel.isRightChevron ? 1 : 0.25)
                            .frame(width: 24, height: 24)
                            .disabled(!calendarViewModel.isRightChevron)
                    }
                }
                .frame(height: 56)
                .padding(.horizontal, .rowPadding)
                
                DateGridView(
                    selectedDate: $selectedDate,
                    range: $range,
                    mode: $mode,
                    scrollViewPosition: $scrollViewPosition,
//                    isMonthYearPickerOpen: $isMonthYearPickerOpen,
                    calendarViewModel: calendarViewModel
                )
                .padding(.horizontal, .rowDateCalendar)
                
                TimeSelectView(selectedStartTime: $selectedStartTime, selectedEndTime: $selectedEndTime, isStartTimePickerOpen: $isStartTimePickerOpen, isEndTimePickerOpen: $isEndTimePickerOpen)
                
                Spacer()
                
                Button("Toggle Mode") {
                    if mode == .range {
                        calendarViewModel.selectedDate1 = nil
                        calendarViewModel.selectedDate2 = nil
                        calendarViewModel.range = nil
                        mode = .single
                    } else {
                        calendarViewModel.selectedDate = nil
                        mode = .range
                    }
                }
            }
            .onAppear {
                if permissibleRange == nil {
                    calendarViewModel.isLeftChevron = true
                    calendarViewModel.isRightChevron = true
                    calendarViewModel.helperDate = Date.now.monthStart
                } else {
                    calendarViewModel.helperDate = permissibleRange?.lowerBound.monthStart ?? Date.now.monthStart
                    let lastDate = permissibleRange?.upperBound ?? Date.now
                    if Date.now.createDate(year: calendarViewModel.helperDate.year, month: calendarViewModel.helperDate.month, day: 1) ?? Date.now >=
                        Date.now.createDate(year: lastDate.year, month: lastDate.month, day: 1) ?? Date.now {
                        calendarViewModel.isRightChevron = false
                    }
                }
            }
            .onChange(of: calendarViewModel.helperDate) {
                withAnimation {
                    scrollViewPosition = calendarViewModel.helperDate
                    calendarViewModel.chevronCheck()
                }
            }
            .disabled(isMonthYearPickerOpen || isStartTimePickerOpen || isEndTimePickerOpen)
//            .disabled(isMonthYearPickerOpen)
            .opacity(isMonthYearPickerOpen || isStartTimePickerOpen || isEndTimePickerOpen ? 0.3 : 1)
//            .opacity(isMonthYearPickerOpen ? 0.5 : 1)
            
            if isStartTimePickerOpen || isEndTimePickerOpen {
                TimeSelectorView(selectedStartTime: $selectedStartTime, selectedEndTime: $selectedEndTime, isStartTimePickerOpen: $isStartTimePickerOpen, isEndTimePickerOpen: $isEndTimePickerOpen)
                    .shadow(radius: 10)
            }
            
            if isMonthYearPickerOpen {
                MonthYearPickerView (          
                    pickerSelectedDate: $calendarViewModel.helperDate,
                    isMonthYearPickerOpen: $isMonthYearPickerOpen,
                    validRange: calendarViewModel.permissibleRange,
                    calendarViewModel: calendarViewModel
                )
                .shadow(radius: 10)
            }
        }
    }
}

enum Mode {
    case single
    case range
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
