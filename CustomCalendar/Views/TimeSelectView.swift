//
//  TimeSelectView.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 25/02/25.
//
import SwiftUI
import DVThemeKit

extension CalendarMainView {
    @ViewBuilder func timeSelectView() -> some View {
        VStack {
            VStack (spacing: 0) {
                Divider()
                timeSelectListItem(label: TimeSelectListLabel.startTime.rawValue, selectedTime: $startTime)
                Divider()
                timeSelectListItem(label: TimeSelectListLabel.endTime.rawValue, selectedTime: $endTime)
            }
            .background(UIConstants.bgCol)
            .onChange(of: startTime) {
                if startTime > endTime {
                    endTime = startTime
                }
            }
            .onChange(of: endTime) {
                if endTime < startTime {
                    startTime = endTime
                }
            }
            
            if isStartTimePickerOpen || isEndTimePickerOpen {
                ZStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            isStartTimePickerOpen = false
                            isEndTimePickerOpen = false
                        }
                        .ignoresSafeArea()
                    
                    DatePicker(
                        "Select Time",
                        selection: isStartTimePickerOpen ? $startTime : $endTime,
                        displayedComponents: .hourAndMinute
                    )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxHeight: .infinity, alignment: .top)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

extension CalendarMainView {
    
    func timeSelectListItem(label: String, selectedTime: Binding<Date>) -> some View {
        var selectedHour: Int {
            Calendar.current.component(.hour, from: selectedTime.wrappedValue)
        }
        var selectedMin: Int {
            Calendar.current.component(.minute, from: selectedTime.wrappedValue)
        }
        
        var Meridiem: String {
            if selectedHour < 12 {
                "AM"
            } else {
                "PM"
            }
        }
        
        return (
            HStack (spacing: 0) {
                Image("timeIcon")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .padding(.trailing, 20)
                Text("\(label)")
                    .fontStyle(.subtitleRegular)
                
                Spacer()
                
                ZStack {
                    Color.systemAlwaysBlackTransparent
                        .frame(width: 99, height: 32)
                        .applyStrokes(.effectStrokeOutline, strokeShape: Rectangle())
                    
                    Text(" \(selectedHourFormatter(selectedHour)) : \(selectedMinFormatter(selectedMin)) \(Meridiem) ")
                        .frame(height: 56)
                        .fontStyle(.subtitleRegular)
                }
            }
            .onTapGesture {
                if isEndTimePickerOpen {
                    isEndTimePickerOpen.toggle()
                } else if isStartTimePickerOpen {
                    isStartTimePickerOpen.toggle()
                }
                
                if label == TimeSelectListLabel.startTime.rawValue {
                    isStartTimePickerOpen = true
                } else {
                    isEndTimePickerOpen = true
                }
            }
            .padding(.leading, .rowPadding)
            .padding(.trailing, .rowSwitchChevQty)
            .overlay {
//                DatePicker("TimePicker", selection: $selectedTime, displayedComponents: .hourAndMinute)
//                    .frame(maxWidth: .infinity)
//                    .datePickerStyle(.graphical)
//                    .tint(UIConstants.todayDateCol)
//                    .colorMultiply(.clear)
//                    .offset(x: -10)
            }
        )
    }
    
    func selectedHourFormatter(_ selectedHour: Int) -> String {
        if selectedHour < 10 {
            return "0\(selectedHour)"
        } else if selectedHour > 12 {
            let tempHour = selectedHour - 12
            if tempHour < 10 {
                return "0\(tempHour)"
            }
            return "\(tempHour)"
        }
        return "\(selectedHour)"
    }
    
    func selectedMinFormatter(_ selectedMin: Int) -> String {
        if selectedMin < 10 {
            return "0\(selectedMin)"
        }
        return "\(selectedMin)"
    }
}


extension CalendarMainView {
    func timeSelectorView() -> some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .containerRelativeFrame([.horizontal, .vertical])
                .onTapGesture {
                    isStartTimePickerOpen = false
                    isEndTimePickerOpen = false
                }
                .ignoresSafeArea()
            
            VStack {
                DatePicker(
                    "Select Time",
                    selection: isStartTimePickerOpen ? $startTime : $endTime,
                    displayedComponents: .hourAndMinute
                )
                        .datePickerStyle(.wheel)
                        .scaleEffect(0.9)
                        .labelsHidden()
            }
            .background(UIConstants.bgCol)
        }
    }
}

enum TimeSelectListLabel: String {
    case startTime = "Start Time"
    case endTime = "End Time"
}
