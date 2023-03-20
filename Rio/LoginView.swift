//
//  LoginView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var isSignUp = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private func signIn() {
        authManager.signIn(email: email, password: password) { result in
            switch result {
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            case .success:
                break
            }
        }
    }

    private func signUp() {
        authManager.signUp(email: email, password: password,  username: username) { (result: Result<User, Error>) in
            switch result {
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            case .success(let user):
                let userId = user.uid
                
                let userModel = UserModel(id: userId, email: email, username: username, posts: [:])
                authManager.createUserInDatabase(user: userModel) { result in
                    switch result {
                    case .failure(let error):
                        alertMessage = error.localizedDescription
                        showAlert = true
                    case .success:
                        break
                    }
                }
            }
        }
    }


    private func passwordIsStrong(_ password: String) -> Bool {
        // Update this function to validate the password strength
        return password.count >= 6
    }

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.bottom, 20)

            if isSignUp {
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.bottom, 20)
            }

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .padding(.bottom, 20)
            
            Button(action: {
                if isSignUp {
                    if passwordIsStrong(password) {
                        signUp()
                    } else {
                        alertMessage = "Password is not strong enough."
                        showAlert = true
                    }
                } else {
                    signIn()
                }
            }, label: {
                Text(isSignUp ? "Sign Up" : "Log In")
                    .foregroundColor(Color.white)
                    .frame(width: 220, height: 50)
                    .background(Color.blue)
                    .cornerRadius(15)
            })
            
            Button(action: {
                isSignUp.toggle()
            }, label: {
                Text(isSignUp ? "Have an account? Log In" : "Don't have an account? Sign Up")
                    .foregroundColor(.blue)
            })
            .padding(.top, 20)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
