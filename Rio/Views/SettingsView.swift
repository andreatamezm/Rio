//
//  SettingsView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI
import FirebaseAuth

// SettingsView displays the current user's username and provides a log out button.
struct SettingsView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    

    var body: some View {
        NavigationView {
            VStack {
                // Add other settings content here, if needed

                Spacer()

                LogoutButton(action: authManager.signOut)
            }
            .navigationBarTitle(Text("Hello, \(authManager.userModel?.username ?? "")"))
        }
    }
}


struct LogoutButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Log Out")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("ButtonGreen"))
                .cornerRadius(10)
        }
        .padding()
    }
}
