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
        
            
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: frameWidth, height: frameHeight)
                    .clipped()
                

                VStack {
                    Spacer()
                    if let caption = caption, !caption.isEmpty, caption != "No caption" {
                        Text(caption)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(8)
                            .padding(.bottom, 16)
                    }
                }
            }
        }
    }
}
