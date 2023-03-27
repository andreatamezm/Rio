//
//  LoadingView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/24/23.
//

import SwiftUI

var loadingView: some View {
    ZStack {
        Color(.systemBackground)
            .opacity(0.5)
            .edgesIgnoringSafeArea(.all)

        ProgressView()
            .scaleEffect(1.5)
    }
}
