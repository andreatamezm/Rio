//
//  CalendarManager.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import Foundation
import Combine

class CalendarManager: ObservableObject {
    public let calendar: Calendar
    @Published var currentDate: Date

    // Initialize the CalendarManager with the current date
    init() {
        self.calendar = Calendar.current
        self.currentDate = Date()
    }
    
    // Return the current month and year as a formatted string
    var monthAndYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: currentDate)
    }
    
    // Return the number of days in the current month
    var daysInMonth: Int {
        calendar.range(of: .day, in: .month, for: currentDate)?.count ?? 0
    }
    
    // Return the index of the starting day of the week for the current month
    var startingDayOfWeek: Int {
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else { return 0 }
        return (calendar.component(.weekday, from: firstDayOfMonth) - calendar.firstWeekday + 7) % 7
    }
    
    // Move to the next month
    func moveToNextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
    }
    
    // Move to the previous month
    func moveToPreviousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
    }
}
