//
//  CalendarDayView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI
import FirebaseAuth

struct CalendarDayView: View {
    let dayIndex: Int
    let rowHeight: CGFloat
    let showImagePicker: (Int) -> Void
    @ObservedObject var calendarManager: CalendarManager
    @EnvironmentObject var imageData: ImageData
    @State private var showOpenImageView = false
    @State private var showChangeImagePicker = false

    var body: some View {
        let currentDay = Calendar.current.component(.day, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let monthOfSelectedDay = Calendar.current.component(.month, from: calendarManager.currentDate)
        let yearOfSelectedDay = Calendar.current.component(.year, from: calendarManager.currentDate)
        
        let isCurrentDay = currentDay == dayIndex && currentMonth == monthOfSelectedDay && currentYear == yearOfSelectedDay
        
        Button(action: {
            if isCurrentDay {
                let key = String(format: "%04d-%02d-%02d", yearOfSelectedDay, monthOfSelectedDay, dayIndex)
                if imageData.imagesForDays[key] == nil {
                    showChangeImagePicker.toggle()
                } else {
                    showOpenImageView.toggle()
                }
            }
        }, label: {
            CalendarDayViewContent(dayIndex: dayIndex, isCurrentDay: isCurrentDay, monthOfSelectedDay: monthOfSelectedDay, yearOfSelectedDay: yearOfSelectedDay) // Pass the current user's ID
                .environmentObject(imageData)
        })
        .frame(maxWidth: .infinity, maxHeight: rowHeight)
        .clipped()
        .sheet(isPresented: $showChangeImagePicker) {
            ImagePicker(selectedImage: .constant(nil), sourceType: .photoLibrary) { image in
                if let image = image {
                    let currentDate = Calendar.current.date(from: DateComponents(year: yearOfSelectedDay, month: monthOfSelectedDay, day: dayIndex))!
                    imageData.createPost(image: image, date: currentDate) { result in
                        switch result {
                        case .success:
                            print("Post created successfully")
                        case .failure(let error):
                            print("Error creating post: \(error.localizedDescription)")
                        }
                    }
                }
                showChangeImagePicker = false
            }
        }
    }
}

    
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
