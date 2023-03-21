//
//  CalendarGridView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI
import FirebaseAuth

// CalendarGridView displays a grid of CalendarWeekView instances,
// representing a full month of calendar weeks.
struct CalendarGridView: View {
    @ObservedObject var calendarManager: CalendarManager
    let rowHeight: CGFloat
    let showImagePicker: (Int) -> Void
    @EnvironmentObject var postData: PostData

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            ForEach(0..<6, id: \.self) { weekIndex in
                CalendarWeekView(week: weekIndex, calendarManager: calendarManager, rowHeight: rowHeight, showImagePicker: showImagePicker)
            }
        }
    }
}
