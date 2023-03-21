//
//  ImageViewer.swift
//  Rio
//
//  Created by Andrea Tamez on 3/20/23.
//

import SwiftUI

struct ImageViewer: View {
    let image: UIImage
    
    var body: some View {
        GeometryReader { geometry in
            let frameWidth = geometry.size.width
            let frameHeight = frameWidth * 16 / 9
            VStack {
                Spacer()
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: frameWidth, height: frameHeight)
                    .clipped()
                Spacer()
            }
        }
    }
}
