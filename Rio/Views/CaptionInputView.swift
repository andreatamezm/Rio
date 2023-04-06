//
//  CaptionInputView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/20/23.
//

import SwiftUI

struct CaptionInputView: View {
    @Binding var caption: String
    var selectedImage: UIImage
    var onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Image("MainAppBackground")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        ZStack {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8 * 16 / 9)
                                .clipped()
                                .cornerRadius(10)

                            VStack {
                                Spacer()
                                TextField("Enter a caption", text: $caption)
                                    .padding(5)
                                    .background(Color("CaptionBackground"))
                                    .foregroundColor(Color("CaptionText"))
                                    .cornerRadius(10)
                                    .padding(.bottom, 40)
                                    .frame(width: geometry.size.width * 0.8 * 0.75)
                            }
                        }
                        .padding(.top, geometry.size.height * 0.1)

                        Button(action: {
                            onSave()
                            presentationMode.wrappedValue.dismiss()
                            print("Post was created successfully")
                        }, label: {
                            Text("Save")
                                .padding()
                                .frame(width: geometry.size.width * 0.8)
                                .background(Color("AccentColor"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.bottom, geometry.size.height * 0.2)
                        })
                    }
                }
            }
        }
    }
}

class CaptionInputData: ObservableObject, Identifiable {
    let id = UUID()
    let selectedImage: UIImage
    @Published var caption: String
    let date: Date?

    init(selectedImage: UIImage, caption: String, date: Date) {
        self.caption = caption
        self.selectedImage = selectedImage
        self.date = date
    }
}
