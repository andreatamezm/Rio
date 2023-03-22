//
//  CalendarWeekView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI
import FirebaseAuth

// CalendarWeekView represents a single week in a calendar grid.
// It displays a row containing seven CalendarDayView instances, one for each day of the week.
struct CalendarWeekView: View {
    let week: Int
    @ObservedObject var calendarManager: CalendarManager
    let rowHeight: CGFloat
    let showImagePicker: (Int) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: -1) {
            ForEach(0..<7, id: \.self) { day in
                dayContent(day)
            }
        }
    }

    private func dayContent(_ day: Int) -> some View {
        if week * 7 + day >= calendarManager.startingDayOfWeek, week * 7 + day < calendarManager.startingDayOfWeek + calendarManager.daysInMonth {
            let dayIndex = week * 7 + day - calendarManager.startingDayOfWeek + 1
            return AnyView(CalendarDayView(dayIndex: dayIndex, rowHeight: rowHeight, showImagePicker: showImagePicker, calendarManager: calendarManager))
        } else {
            return AnyView(Text("").frame(maxWidth: .infinity, maxHeight: rowHeight))
        }
    }
}
