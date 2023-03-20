//
//  CalendarGridView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI
import FirebaseAuth


struct CalendarGridView: View {
    @ObservedObject var calendarManager: CalendarManager
    let rowHeight: CGFloat
    let showImagePicker: (Int) -> Void
    @EnvironmentObject var imageData: ImageData

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            ForEach(0..<6, id: \.self) { week in
                CalendarWeekView(week: week, calendarManager: calendarManager, rowHeight: rowHeight, showImagePicker: showImagePicker)
            }
        }
    }
}

