//
//  CalendarDayView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//
import SwiftUI
import FirebaseAuth

// CalendarDayView is a custom View component that represents a single day in a calendar grid.
// It displays a day's number and associated image, if available.
// If the day is the current day, the user can tap on it to either open an existing image or show an ImagePicker to select a new one.
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
            let key = String(format: "%04d-%02d-%02d", yearOfSelectedDay, monthOfSelectedDay, dayIndex)
            if imageData.imagesForDays[key] == nil && isCurrentDay {
                showImagePicker(dayIndex)
            } else if imageData.imagesForDays[key] != nil {
                showOpenImageView = true
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
        .sheet(isPresented: $showOpenImageView) {
            if let imageKey = String(format: "%04d-%02d-%02d", yearOfSelectedDay, monthOfSelectedDay, dayIndex),
               let image = imageData.imagesForDays[imageKey] {
                ImageViewer(image: image)
            } else {
                EmptyView()
            }
        }

    }
}
