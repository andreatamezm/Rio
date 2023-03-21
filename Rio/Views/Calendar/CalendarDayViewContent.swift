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
    @EnvironmentObject var postData: PostData

    var body: some View {
        GeometryReader { geometry in
            let frameWidth = geometry.size.width
            let frameHeight = frameWidth * 16 / 9
            
            ZStack {
                Rectangle()
                    .fill(isCurrentDay ? Color(hex: "CBE0EA") : Color(hex: "CBE0EA").opacity(0.5))
                
                let key = String(format: "%04d-%02d-%02d", yearOfSelectedDay, monthOfSelectedDay, dayIndex)

                if let image = postData.imagesForDays[key] {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: frameWidth, height: frameHeight)
                                .clipped()
                        }
                
                Rectangle()
                    .stroke(Color.gray, lineWidth: 1)
                
                Text("\(dayIndex)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                    
            }
            .frame(width: frameWidth, height: frameHeight)
        }
    }
}
