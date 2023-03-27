//
//  ImageViewer.swift
//  Rio
//
//  Created by Andrea Tamez on 3/20/23.
//

import SwiftUI

struct ImageViewer: View {
    let image: UIImage
    let caption: String
    

    var body: some View {
        GeometryReader { geometry in
            let frameWidth = geometry.size.width
            let frameHeight = frameWidth * 16 / 9
            
            NavigationView {
                ZStack {
                    Image("MainAppBackground")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .clipped()
                        
                        
                        VStack {
                            Spacer()
                            if let caption = caption, !caption.isEmpty, caption != "No caption" {
                                Text(caption)
                                    .padding(5)
                                    .background(Color("CaptionBackground"))
                                    .foregroundColor(Color("CaptionText"))
                                    .cornerRadius(10)
                                    .padding(.bottom, 40)
                                    .frame(width: frameWidth - 40)
                            }
                        }
                    }
                }
            }
        }
    }
}
