//
//  DaysOfWeekView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI

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
