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
        VStack {
            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            TextField("Enter a caption", text: $caption)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top)
            
            Button(action: {
                onSave()
                presentationMode.wrappedValue.dismiss() 
                print("Post was created successfully") // Add this line
            }, label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            })
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
