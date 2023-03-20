//
//  SettingsView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        NavigationView {
            VStack {
                // Display current user's username
                if let user = authManager.userModel {
                    Text("Username: \(user.username)")
                        .font(.headline)
                        .padding()
                }

                // Add other settings content here, if needed

                Spacer()

                Button(action: {
                    authManager.signOut()
                }, label: {
                    Text("Log Out")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                })
                .padding()

                Spacer()
            }
            .navigationBarTitle("Settings")
        }
    }
}
