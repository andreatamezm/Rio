//
//  CalendarView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI
import FirebaseAuth


struct CalendarView: View {
    @EnvironmentObject var calendarManager: CalendarManager
    @EnvironmentObject var imageData: ImageData
    @State private var currentSelectedDay: String?
    @State private var showingImagePicker = false
    private let rowHeight: CGFloat = 100

    func showImagePicker(for day: Int) {
        let year = Calendar.current.component(.year, from: calendarManager.currentDate)
        let month = Calendar.current.component(.month, from: calendarManager.currentDate)
        let key = String(format: "%04d-%02d-%02d", year, month, day)

        currentSelectedDay = key
        showingImagePicker = true
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "90DFFE"), Color(hex: "38A3D1")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 0.0) {
                    HStack {
                        Button(action: {
                            calendarManager.moveToPreviousMonth()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .font(.title)
                        })
                        Text(calendarManager.monthAndYear)
                            .font(.system(size: 22, weight: .bold))
                        Button(action: {
                            calendarManager.moveToNextMonth()
                        }, label: {
                            Image(systemName: "chevron.right")
                                .font(.title)
                        })
                    }
                    
                    DaysOfWeekView()
                    
                    CalendarGridView(calendarManager: calendarManager, rowHeight: rowHeight, showImagePicker: showImagePicker)
                        .environmentObject(imageData)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .onAppear {
                if let userId = Auth.auth().currentUser?.uid {
                    calendarManager.currentDate = Date()
                    imageData.currentUserId = userId
                    imageData.fetchPostsForUser(userId: userId) { (result: Result<[String: PostModel], Error>) in
                        switch result {
                        case .success(let posts):
                            imageData.fetchImagesForUser(posts: posts) { result in
                                switch result {
                                case .success:
                                    print("Images fetched successfully.")
                                case .failure(let error):
                                    print("Error fetching user's images: \(error.localizedDescription)")
                                }
                            }
                        case .failure(let error):
                            print("Error fetching user's posts: \(error.localizedDescription)")
                        }
                    }
                }
            }








        }
        .sheet(isPresented: $showingImagePicker, onDismiss: {
            if let selectedDay = currentSelectedDay, let image = imageData.imagesForDays[selectedDay] {
                print("Image selected for day \(selectedDay): \(image)")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let date = dateFormatter.date(from: selectedDay) {
                    imageData.createPost(image: image, date: date) { result in
                        switch result {
                        case .success:
                            print("Post created successfully.")
                        case .failure(let error):
                            print("Error creating post: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }, content: {
            ImagePicker(selectedImage: Binding(get: {
                currentSelectedDay.flatMap { imageData.imagesForDays[$0] }
            }, set: { newValue in
                if let selectedDay = currentSelectedDay, let image = newValue {
                    imageData.updateImageForDay(day: selectedDay, image: image)
                }
            }), sourceType: .photoLibrary)
        })
    }
}
