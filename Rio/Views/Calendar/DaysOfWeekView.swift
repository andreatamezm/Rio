//
//  DaysOfWeekView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI

// DaysOfWeekView displays the names of the days of the week in a horizontal stack.
struct DaysOfWeekView: View {
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        HStack(alignment: .center, spacing: -1) {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color("DaysOfWeek"))
            }
        }
    }
}
