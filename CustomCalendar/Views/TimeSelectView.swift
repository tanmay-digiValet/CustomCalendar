//
//  TimeSelectView.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 25/02/25.
//
import SwiftUI
import DVThemeKit

struct TimeSelectView: View {
    @Binding var selectedStartTime: Date
    @Binding var selectedEndTime: Date
    @Binding var isStartTimePickerOpen: Bool
    @Binding var isEndTimePickerOpen: Bool
    
    var body: some View {
        VStack (spacing: 0) {
            Divider()
            TimeSelectListItem(label: "Start Time", selectedTime: $selectedStartTime, isPickerOpen: $isStartTimePickerOpen)
            Divider()
            TimeSelectListItem(label: "End time", selectedTime: $selectedEndTime, isPickerOpen: $isEndTimePickerOpen)
        }
        .background(UIConstants.bgCol)
        .opacity(isStartTimePickerOpen || isEndTimePickerOpen ? 0.5 : 1)
        .frame(maxHeight: .infinity, alignment: .top)
        .onChange(of: selectedStartTime) {
            if selectedStartTime > selectedEndTime {
                selectedEndTime = selectedStartTime
            }
        }
        .onChange(of: selectedEndTime) {
            if selectedEndTime < selectedStartTime {
                selectedStartTime = selectedEndTime
            }
        }
    }
}

struct TimeSelectListItem: View {
    var label: String
    @Binding var selectedTime: Date
    @Binding var isPickerOpen: Bool
    
    var selectedHour: Int {
        Calendar.current.component(.hour, from: selectedTime)
    }
    var selectedMin: Int {
        Calendar.current.component(.minute, from: selectedTime)
    }
    
    var MeridiemIndicator: String {
        if selectedHour < 12 {
            "AM"
        } else {
            "PM"
        }
    }
    
    var body: some View {
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
                    
                    Text(" \(selectedHourFormatter(selectedHour)) : \(selectedMinFormatter(selectedMin)) \(MeridiemIndicator) ")
                        .frame(height: 56)
                        .fontStyle(.subtitleRegular)
                }
            }
            .onTapGesture {
                isPickerOpen = true
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

struct TimeSelectorView: View {
    @Binding var selectedStartTime: Date
    @Binding var selectedEndTime: Date
    @Binding var isStartTimePickerOpen: Bool
    @Binding var isEndTimePickerOpen: Bool
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    isStartTimePickerOpen = false
                    isEndTimePickerOpen = false
                }
                .ignoresSafeArea()
            
            VStack {
                DatePicker(
                    "Select Month & Year",
                    selection: isStartTimePickerOpen ? $selectedStartTime : $selectedEndTime,
                    displayedComponents: .hourAndMinute
                )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
            }
            .frame(width: 330, height: 230)
            .background(UIConstants.bgCol)
            .cornerRadius(20)
        }
    }
}


//#Preview {
//    TimeSelectView()
//}
