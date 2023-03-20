//
//  AuthenticationManager.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthenticationManager: ObservableObject {
    @Published var user: User?
    private var handle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()
    @Published var userModel: UserModel?
    @Published var imageData = ImageData()
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            self.user = user
            if let user = user {
                self.fetchUserData(userId: user.uid) { result in
                    switch result {
                    case .failure(let error):
                        print("Error fetching user data: \(error)")
                    case .success(let userModel):
                        DispatchQueue.main.async {
                            self.userModel = userModel
                            self.imageData.updateImagesForDays(posts: Array(userModel.posts.values))
                        }
                    }
                }
            } else {
                self.userModel = nil
                self.imageData.imagesForDays.removeAll()
            }
        }
    }
    
    func signUp(email: String, password: String, username: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let newUserModel = UserModel(id: user.uid, email: email, username: username, posts: [:])
                self.createUserInDatabase(user: newUserModel) { createUserResult in
                    switch createUserResult {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success:
                        completion(.success(user))
                    }
                }
            }
        }
    }

    

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    private func fetchUserData(userId: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                do {
                    let userModel = try document.data(as: UserModel.self)
                    completion(.success(userModel))
                    print("UserModel fetched: { username: " + userModel.username + " email: " + userModel.email + " userID: " + userModel.id)
                    print("UserModel posts fetched: \(userModel.posts.count)")
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
            }
        }
    }

    
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func createUserInDatabase(user: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let _ = try db.collection("users").document(user.id).setData(from: user)
        } catch {
            completion(.failure(error))
        }
    }

    
    func unlisten() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
