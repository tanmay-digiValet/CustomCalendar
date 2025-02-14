//
//  CalendarMainView.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 10/02/25.
//

import SwiftUI

struct CalendarMainView: View {
    
    // MARK: Dependencies
    var permissibleRange: ClosedRange<Date>? = nil
    @Binding var range: ClosedRange<Date>?
    @Binding var selectedDate: Date?
    @State var selectedRange: ClosedRange<Date>? = nil
    var disabledDays: [Weekday] = []
    var disabledDates: [Date] = []
    @Binding var mode: Mode
    
    // MARK: Local states and variables
    // MARK: initially assigned lowerBound of permissibleRange (in onAppear),
    // MARK: intended to keep track and enable transition of active month and year.
    @State var helperDate: Date = Date.now.monthStart
    @State var selectedDate1: Date? = nil
    @State var selectedDate2: Date? = nil
    @State var scrollViewPosition: Date? = nil
    @State var isMonthYearPickerOpen: Bool = false
    
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
            VStack (alignment: .leading) {
                HStack (spacing: 20) {
                    HStack(spacing: 5) {
                        Text("\(calendarViewModel.helperDate.formatted(.dateTime.month()))")
                            .font(.system(size: 28))
                            .animation(.easeInOut(duration: 0.2), value: calendarViewModel.helperDate.month)
                            .contentTransition(.numericText(value: Double(calendarViewModel.helperDate.month)))
                        
                        Text("\(calendarViewModel.helperDate.formatted(.dateTime.year()))")
                            .font(.system(size: 28))
                            .animation(.easeInOut(duration: 0.2), value: calendarViewModel.helperDate.year)
                            .contentTransition(.numericText(value: Double(calendarViewModel.helperDate.year)))
                        
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                    }
                    .onTapGesture {
                        isMonthYearPickerOpen = true
                    }
                    .animation(.easeInOut, value: calendarViewModel.helperDate)
                    
                    Spacer()
                    
                    Button(
                        action: {
                            withAnimation {
                                calendarViewModel.lowerBoundCheck()
                            }
                        } ) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .foregroundStyle(.black)
                    }
                        .opacity(calendarViewModel.isLeftChevron ? 1 : 0.25)
                        .disabled(!calendarViewModel.isLeftChevron)
                    
                    Button(
                        action: {
                            withAnimation {
                                calendarViewModel.upperBoundCheck()
                            }
                        }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .foregroundStyle(.black)
                    }
                        .opacity(calendarViewModel.isRightChevron ? 1 : 0.25)
                        .disabled(!calendarViewModel.isRightChevron)
                    
                }
                .padding(.bottom, 21)
                .padding(.horizontal, 10)
                .padding(.trailing, 10)
                
                DateGridView(
                    selectedDate: $selectedDate,
                    range: $range,
                    mode: $mode,
                    selectedDate1: $selectedDate1,
                    selectedDate2: $selectedDate2,
                    scrollViewPosition: $scrollViewPosition,
                    isMonthYearPickerOpen: $isMonthYearPickerOpen,
                    calendarViewModel: calendarViewModel
                )
            }
            .onAppear {
                if permissibleRange == nil {
                    calendarViewModel.isLeftChevron = true
                    calendarViewModel.isRightChevron = true
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
            .padding(.horizontal, 16)
            .disabled(isMonthYearPickerOpen)
            .opacity(isMonthYearPickerOpen ? 0.5 : 1)
            
            if isMonthYearPickerOpen {
                withAnimation {
                    MonthYearPickerView(
                        pickerSelectedDate: $calendarViewModel.helperDate,
                        isMonthYearPickerOpen: $isMonthYearPickerOpen,
                        validRange: calendarViewModel.permissibleRange
                    )
                        .shadow(radius: 10)
                }
                    
            }
        }
    }
}

struct MonthYearPickerView: View {
    
    @Binding var pickerSelectedDate: Date
    @Binding var isMonthYearPickerOpen: Bool
    var validRange: ClosedRange<Date>?
    
    var body: some View {
            VStack {
                ZStack {
                    DatePicker(
                        "Select Month & Year",
                        selection: $pickerSelectedDate,
                        in:
                            (validRange?.lowerBound.monthStart ?? Date.now)...(validRange?.upperBound ?? Date.now),
                        displayedComponents: [.date]
                    )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    
                    Color.white
                        .frame(width: 60, height: 180)
                        .offset(x: -115)
                    
                    Color(red: 242/255, green: 242/255, blue: 243/255)
                        .cornerRadius(10)
                        .frame(width: 30, height: 35)
                        .offset(x: -85)
                }
                .offset(x: -30)
                Button ("Done") {
                    isMonthYearPickerOpen = false
                }
                .padding(.bottom, 30)
            }
            .frame(width: 350, height: 250)
            .background(.white)
            .cornerRadius(20)
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
