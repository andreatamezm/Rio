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
                        Text("Settings")
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


struct MainTabView_Previews: PreviewProvider {
    
    static var previews: some View {
       var calendarManager = CalendarManager()
         var authManager = AuthenticationManager()
         var postData = PostData()
         var friendsList = FriendsList()
        
        MainTabView()
            .environmentObject(calendarManager)
            .environmentObject(authManager)
            .environmentObject(postData)
            .environmentObject(friendsList)
    }
}
