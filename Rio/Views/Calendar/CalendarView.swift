//
//  CalendarView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth


struct CalendarView: View {
    @EnvironmentObject var calendarManager:CalendarManager
    @EnvironmentObject var postData: PostData
    @State private var currentSelectedDay: String?
    @State private var showingImagePicker = false
    @State private var captionInputData: CaptionInputData?
    private let rowHeight: CGFloat = 100
    
    func showImagePicker(for day: Int) {
        let year = Calendar.current.component(.year, from: calendarManager.currentDate)
        let month = Calendar.current.component(.month, from: calendarManager.currentDate)
        let key = String(format: "%04d-%02d-%02d", year, month, day)
        
        currentSelectedDay = key
        showingImagePicker = true
    }
    
    // Fetches the user's posts and images when the view appears
    private func fetchData() {
        if let userId = Auth.auth().currentUser?.uid {
            calendarManager.currentDate = Date()
            postData.currentUserId = userId
            postData.listenToPostsForUser(userId: userId) { (result: Result<[String: PostModel], Error>) in
                switch result {
                case .success(let posts):
                    
                    postData.fetchImagesForUser(posts: posts) { result in
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
    
    
    // Provides the content for the image picker sheet
    private func imagePickerSheet() -> some View {
        ImagePicker(selectedImage: Binding(get: {
            currentSelectedDay.flatMap { postData.imagesForDays[$0] }
        }, set: { newValue in
            if let selectedDay = currentSelectedDay, let image = newValue {
                postData.updateImageForDay(day: selectedDay, image: image)
            }
        }), sourceType: .photoLibrary)
    }
    
    // Processes the selected image when the image picker is dismissed
    private func processSelectedImage() {
        if let selectedDay = currentSelectedDay, let image = postData.imagesForDays[selectedDay] {
            print("Image selected for day \(selectedDay): \(image)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: selectedDay) {
                // Show the caption input view
                captionInputData = CaptionInputData(selectedImage: image, caption: "", date: date)
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("MainAppBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                GeometryReader { geo in
                    VStack(alignment: .center, spacing: 0.0) {
                        HStack {
                            Button(action: {
                                calendarManager.moveToPreviousMonth()
                            }, label: {
                                Image(systemName: "chevron.left")
                                    .font(.title)
                                    .frame(maxWidth: 18, alignment: .leading)
                                    .padding(10)
                                    .foregroundColor(Color("Arrows"))
                            })
                            
                            Text(calendarManager.monthAndYear)
                                .font(.system(size: geo.size.width * 0.05, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(Color("AccentColor"))
                            
                            Button(action: {
                                calendarManager.moveToNextMonth()
                            }, label: {
                                Image(systemName: "chevron.right")
                                    .font(.title)
                                    .frame(maxWidth: 18, alignment: .trailing)
                                    .padding(10)
                                    .foregroundColor(Color("Arrows"))
                                
                            })
                        }
                        .background(Color("MonthYearNavTab"))
                        .cornerRadius(10)
                        .padding(.top, geo.size.height * 0.1)
                        .padding([.leading, .trailing, .bottom], geo.size.width * 0.03)
                        
                        DaysOfWeekView()
                            .padding(2)
                        
                        CalendarGridView(calendarManager: calendarManager, rowHeight: geo.size.height * 0.1, showImagePicker: showImagePicker)
                            .environmentObject(postData)
                            .padding(5)
                        
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    
                }
            }
            .onAppear {
                fetchData()
            }
            .animation(.default)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: processSelectedImage, content: imagePickerSheet)
        .sheet(item: $captionInputData) { data in
            CaptionInputView(caption: Binding(get: { data.caption }, set: { newValue in data.caption = newValue }), selectedImage: data.selectedImage, onSave: {
                if let userId = postData.currentUserId, let date = data.date {
                    postData.createPost(image: data.selectedImage, caption: data.caption, date: date) { result in
                        switch result {
                        case .success:
                            print("Post created successfully.")
                        case .failure(let error):
                            print("Error creating post: \(error.localizedDescription)")
                        }
                    }
                }
            })
            .environmentObject(postData)
        }
    }
    
}
