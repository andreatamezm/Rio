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
                    
                    VStack {
                        Image("memories") // Use your custom image
                            .renderingMode(.template)
                        Text("Memories")
                    }
                    
                }
            
            FeedView()
                .environmentObject(friendsList)
                .tabItem {
                    
                    VStack {
                        Image("feed") // Use your custom image
                            .renderingMode(.template)
                        Text("Feed")
                    }
                }
            
            SettingsView()
                .environmentObject(authManager)
                .tabItem {
                    
                    VStack {
                        Image("line") // Use your custom image
                            .renderingMode(.template)
                        Text("Menu")
                    }
                }
        }
        .tabBarBackground(Color("NavBarFill")) // Add this line
        .selectedTabColor(Color("AccentColor")) // Add this line
        
    }
}


extension View {
    func tabBarBackground(_ color: Color) -> some View {
        return self.onAppear {
            let uiColor = UIColor(color)
            UITabBar.appearance().barTintColor = uiColor
            UITabBar.appearance().backgroundColor = uiColor
            UITabBar.appearance().isTranslucent = false
        }
    }
    
    func selectedTabColor(_ color: Color) -> some View {
        return self.onAppear {
            let uiColor = UIColor(color)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: uiColor], for: .selected)
            UITabBar.appearance().tintColor = uiColor
        }
    }
}
