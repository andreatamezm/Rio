//
//  CalendarWeekView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI
import FirebaseAuth

struct CalendarWeekView: View {
    let week: Int
    @ObservedObject var calendarManager: CalendarManager
    let rowHeight: CGFloat
    let showImagePicker: (Int) -> Void

    var body: some View {
        HStack {
            ForEach(0..<7, id: \.self) { day in
                if week * 7 + day >= calendarManager.startingDayOfWeek, week * 7 + day < calendarManager.startingDayOfWeek + calendarManager.daysInMonth {
                    let dayIndex = week * 7 + day - calendarManager.startingDayOfWeek + 1
                    CalendarDayView(dayIndex: dayIndex, rowHeight: rowHeight, showImagePicker: showImagePicker, calendarManager: calendarManager)
                } else {
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: rowHeight)
                }
            }
        }
    }
}
