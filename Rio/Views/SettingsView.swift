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
                // Display current user's username
                if let user = authManager.userModel {
                    UsernameView(user: user)
                }

                // Add other settings content here, if needed

                Spacer()

                LogoutButton(action: authManager.signOut)

                Spacer()
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct UsernameView: View {
    let user: UserModel

    var body: some View {
        Text("Username: \(user.username)")
            .font(.headline)
            .padding()
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
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding()
        .buttonStyleModifier()
    }
}

extension View {
    func buttonStyleModifier() -> some View {
        self.modifier(ButtonStyleModifier())
    }
}

struct ButtonStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

