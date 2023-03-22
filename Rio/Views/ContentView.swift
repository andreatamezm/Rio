//
//  ContentView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI

// ContentView serves as the main entry point for the application, it manages authentication state and displays the appropriate view.
struct ContentView: View {
    @StateObject private var calendarManager = CalendarManager()
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var postData = PostData()
    @EnvironmentObject var friendsList: FriendsList


    var body: some View {
        NavigationView {
            if let _ = authManager.user {
                MainTabView()
                    .environmentObject(calendarManager)
                    .environmentObject(authManager)
                    .environmentObject(postData)
                    .environmentObject(friendsList)
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

