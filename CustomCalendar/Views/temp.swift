//
//  temp.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 12/02/25.
//

import SwiftUI

//struct Temp: View {
//    
//    @State private var scrollViewPosition: Int?
//    
//    private let cols = Array(repeating: GridItem(.flexible()), count: 7)
//    
//    var body: some View {
//        ScrollView(.horizontal) {
//            LazyHStack(spacing: 32) {
//                ForEach(1..<21) { item in
//                    LazyVGrid(columns: cols){
//                        Text("Hello")
//                            .frame(width: 200)
//                    }
//                    .id(item)
//                    
//                }
//            }
//            
//            .scrollTargetLayout()
//            .padding()
//        }
//        .onChange(of: scrollViewPosition){
//            print("inside", scrollViewPosition!)
//        }
//        .scrollTargetBehavior(.viewAligned)
//        .scrollPosition(id: $scrollViewPosition)
//    }
//}

struct Temp: View {
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            VStack {
                ZStack {
                    DatePicker("Select Month & Year", selection: $selectedDate, in: (Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 28)) ?? Date.now)...(Calendar.current.date(from: DateComponents(year: 2035, month: 12, day: 28)) ?? Date.now), displayedComponents: [.date])
                        .datePickerStyle(.wheel)
                        .labelsHidden() // Hides the label if needed
                        
                    
                }
                Text("Selected: \(formattedDate)")
                    .padding()
            }
            .frame(width: 350, height: 250)
            .background(.white)
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }

    func getFirstDayOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }
}


#Preview {
    Temp()
}
