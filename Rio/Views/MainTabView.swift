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
    @EnvironmentObject var postData: PostData
    @EnvironmentObject var friendsList: FriendsList

    
    var body: some View {
        TabView {
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            
            FeedView()
                .environmentObject(friendsList)
                .tabItem {
                    Label("Feed", systemImage: "photo")
                }
            
            SettingsView()
                .environmentObject(authManager)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                    
                }
        }.accentColor(Color("ButtonGreen"))
    }
}

