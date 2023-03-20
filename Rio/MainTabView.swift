//
//  MainTabView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var calendarManager: CalendarManager
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var imageData: ImageData
    
    var body: some View {
        TabView {
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            
//            FeedView(calendarManager: calendarManager)
//                .environmentObject(imageData)
//                .tabItem {
//                    Label("Feed", systemImage: "rectangle.grid.1x2")
//                }
            
            SettingsView()
                .environmentObject(authManager)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
