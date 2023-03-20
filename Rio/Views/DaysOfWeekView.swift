//
//  DaysOfWeekView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI

// DaysOfWeekView displays the names of the days of the week in a horizontal stack.
struct DaysOfWeekView: View {
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
