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

    
    init() {
        self.calendar = Calendar.current
        self.currentDate = Date()
    }
    
    var monthAndYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: currentDate)
    }
    
    var daysInMonth: Int {
        calendar.range(of: .day, in: .month, for: currentDate)?.count ?? 0
    }
    
    var startingDayOfWeek: Int {
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else { return 0 }
        return (calendar.component(.weekday, from: firstDayOfMonth) - calendar.firstWeekday + 7) % 7
    }
    
    func moveToNextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
    }
    
    func moveToPreviousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
    }
    
}
