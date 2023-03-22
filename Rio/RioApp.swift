//
//  RioApp.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI

@main
struct RioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var friendsList = FriendsList()


    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(authManager)
                    .environmentObject(friendsList)
                Spacer()
            }
        }
    }
}
