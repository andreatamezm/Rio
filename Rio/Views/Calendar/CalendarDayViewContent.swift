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
                
                Image(isCurrentDay ? "currentDay" : "notCurrentDay")

                if let image = postData.imagesForDays[key] {
                    ZStack {
                        Rectangle()
                            .fill(Color.clear)
                            .border(isCurrentDay ? Color("AccentColor") : Color("CalendarDayStroke"), width: 2)
                            .cornerRadius(5)
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: frameWidth - 9, height: frameHeight - 9)
                            .cornerRadius(3)
                            .clipped()
                    }

                    
                }
                
                
                VStack {
                    Spacer()
                    HStack {
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(isCurrentDay ? Color("CalendarDayTextBackground") : Color("CalendarDayTextBackground_Current"))
                                .frame(
                                    width: 20,
                                    height: 20,
                                    alignment: .bottomLeading)
                            
                            
                            Text("\(dayIndex)")
                                .font(.custom("Helvetica", size: 14))
                                .fontWeight(.regular)
                                .foregroundColor(isCurrentDay ? Color("CalendarDayText_Current") : Color("CalendarDayText"))
                        }
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 0))

                    
                }
                
                .frame(maxWidth: frameWidth)
                    
            }
            
            .frame(maxWidth: .infinity, maxHeight: rowHeight)
            .padding(3)
            
        }
    }
}
