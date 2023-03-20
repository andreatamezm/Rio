//
//  CalendarDayViewContent.swift
//  Rio
//
//  Created by Andrea Tamez on 3/20/23.
//

import SwiftUI

// CalendarDayViewContent is a custom View component that renders the content inside a CalendarDayView.
// It displays the background, an optional user image, a border around the cell, and the day's number.
// The background color varies depending on whether the day is the current day or not.
struct CalendarDayViewContent: View {
    let dayIndex: Int
    let isCurrentDay: Bool
    let monthOfSelectedDay: Int
    let yearOfSelectedDay: Int
    @EnvironmentObject var imageData: ImageData

    var body: some View {
        GeometryReader { geometry in
            let frameWidth = geometry.size.width
            let frameHeight = frameWidth * 16 / 9
            
            ZStack {
                Rectangle()
                    .fill(isCurrentDay ? Color(hex: "CBE0EA") : Color(hex: "CBE0EA").opacity(0.5))
                
                let key = String(format: "%04d-%02d-%02d", yearOfSelectedDay, monthOfSelectedDay, dayIndex)

                if let image = imageData.imagesForDays[key] {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: frameWidth, height: frameHeight)
                                .clipped()
                        }
                
                Rectangle()
                    .stroke(Color.black, lineWidth: 1)
                    .cornerRadius(3)
                
                Text("\(dayIndex)")
                    .font(.system(size: 16, weight: .bold))
            }
            .frame(width: frameWidth, height: frameHeight)
        }
    }
}