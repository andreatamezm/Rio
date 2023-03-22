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
    let rowHeight: CGFloat
    @EnvironmentObject var postData: PostData

    
    var body: some View {
        GeometryReader { geometry in
            let frameWidth = geometry.size.width
            let frameHeight = frameWidth * 16 / 9
            
            ZStack {
                Rectangle()
                    .fill(isCurrentDay ? Color("CalendarDayFill_Current") : Color("CalendarDayFill"))
                    .border(isCurrentDay ? Color("AccentColor") : Color("CalendarDayStroke"), width: 2)
                    .cornerRadius(5)
                
                let key = String(format: "%04d-%02d-%02d", yearOfSelectedDay, monthOfSelectedDay, dayIndex)

                if let image = postData.imagesForDays[key] {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: frameWidth, height: frameHeight)
                                .clipped()
                        }
                VStack {
                    Spacer()
                    Text("\(dayIndex)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isCurrentDay ? Color("CalendarDayText_Current") : Color("CalendarDayText"))
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .bottomLeading)
                        .padding(2)
                }
                
                .frame(maxWidth: frameWidth)
                    
            }
            
            .frame(maxWidth: .infinity, maxHeight: rowHeight)
            .padding(3)
            
        }
    }
}
