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
            ZStack {
                Image("MainAppBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                
                VStack {
                    HStack {
                        Text("Hello, \(authManager.userModel?.username ?? "")")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color("AccentColor"))
                            .padding(.top, 140)

                        Spacer()
                    }
                    .padding(.horizontal)

                    
                    VStack {
                        LogoutButton(action: authManager.signOut)
                    }
                    .padding(.bottom, 80)
                }
            }
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
                .background(Color("AccentColor"))
                .cornerRadius(10)

        }
        .padding(.horizontal)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        var authManager = AuthenticationManager()

        SettingsView()
            .environmentObject(authManager)

    }
}

