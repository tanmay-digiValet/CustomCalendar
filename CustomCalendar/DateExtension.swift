//
//  DateExtension.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 07/02/25.
//
import Foundation
import DVFoundation

extension Date {
    //    static var firstDayOfWeek = Calendar.current.firstWeekday
    
    func createDate(year: Int, month: Int, day: Int) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //        formatter.timeZone = TimeZone.gmt
        return formatter.date(from: "\(year)-\(month)-\(day)")
    }
    
    //    // MARK: Gives last day of previous month, so we need nextDay to get the start of month
    var monthStart: Date {
        self.beginning(of: .month) ?? Date.now
    }

    var nextDay: Date { self.adding(.day, value: 1) }

    // MARK: components.day is decreamented by 1 as adding entire month would return the first day of next month.
    var monthEnd: Date { self.end(of: .month) ?? Date.now }

    var numberOfDaysInMonth: Int? {
        self.end(of: .month)?.day
    }

//    var startWeekdayOfMonth: Int {
//        Calendar.current.component(.weekday, from: monthStart)
//    }


}
