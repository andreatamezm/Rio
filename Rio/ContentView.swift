//
//  ContentView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var calendarManager = CalendarManager()
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var imageData = ImageData()

    var body: some View {
        NavigationView {
            if let _ = authManager.user {
                MainTabView()
                    .environmentObject(calendarManager)
                    .environmentObject(authManager)
                    .environmentObject(imageData)
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
        .onAppear {
            authManager.listen()
        }
        .onDisappear {
            authManager.unlisten()
        }
    }
}
    
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
