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
        HStack {
            TabView {
                CalendarView()
                    .tabItem {
                        Label("Memories", systemImage: "calendar")
                    }
                
                FeedView()
                    .environmentObject(friendsList)
                    .tabItem {
                        Label("Feed", systemImage: "photo")
                        
                    }
                
                SettingsView()
                    .environmentObject(authManager)
                    .tabItem {
                        Label("More", systemImage: "ellipsis")
                        
                    }
            }
            .tabBarBackground(Color("NavBarFill"))
            .selectedTabColor(Color("AccentColor"))
            
        }
        .background(Color(.blue))
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
