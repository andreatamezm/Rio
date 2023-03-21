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
    
    // Sign in an existing user
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

    // Sign up a new user
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

    // Check if the given password is strong enough
    private func passwordIsStrong(_ password: String) -> Bool {
        // Update this function to validate the password strength
        return password.count >= 6
    }
    
    // Custom View Modifier for TextField and SecureField styling
    struct TextFieldStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("TextBoxGray"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.lightGray), lineWidth: 1)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.bottom, 20)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            
            VStack(spacing: -UIScreen.main.bounds.height/30) {
                // Image on the top half
                ZStack {
                    Image("LogInBackground")
                        .resizable()
                        .ignoresSafeArea(edges: .top)
                    
                    VStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 190)
                            .padding(.top, 40)
                    }
                }
                
                // White background with Text Boxes and Buttons on the bottom half
                ZStack() {
                    VStack(spacing: 20) {
                        Spacer()
                        TextField("Email", text: $email)
                            .modifier(TextFieldStyle())
                        
                        SecureField("Password", text: $password)
                            .modifier(TextFieldStyle())
                        
                        // Only ask for username when signing up
                        if isSignUp {
                            TextField("Username", text: $username)
                                .modifier(TextFieldStyle())
                        }
                        
                        
                        // SignUp / LogIn button
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
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color("ButtonGreen"))
                                .cornerRadius(15)
                        })
                        
                        // Change from LogIn to SignUp
                        Button(action: {
                            isSignUp.toggle()
                        }, label: {
                            Text(isSignUp ? "Have an account? Log In" : "Don't have an account? Sign Up")
                                .foregroundColor(Color("ButtonGreen"))
                        })
                        Spacer()
                    }
                    .padding()
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .background(Color.white) // set background color
                    .cornerRadius(30)
                    
                    
                }
                .frame(height: geometry.size.height/2)

            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        var authManager = AuthenticationManager()

        LoginView()
            .environmentObject(authManager)

    }
}
