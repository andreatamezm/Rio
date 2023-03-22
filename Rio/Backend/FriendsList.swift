//
//  FriendsList.swift
//  Rio
//
//  Created by Andrea Tamez on 3/21/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class FriendsList: ObservableObject {
    @Published var friends: [String: UserModel] = [:]
    @Published var friendModels: [String: FriendModel] = [:] // Add this line
    
    private let db = Firestore.firestore()
    
    // MARK: - Public Methods
    
    func fetchFriendsForUser(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("friends").whereField("isAccepted", isEqualTo: true).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let querySnapshot = querySnapshot {
                let dispatchGroup = DispatchGroup()
                var fetchError: Error?
                
                for document in querySnapshot.documents {
                    let friendModel = try? Firestore.Decoder().decode(FriendModel.self, from: document.data())
                    if let friendModel = friendModel {
                        if friendModel.user1ID == userId || friendModel.user2ID == userId {
                            let friendId = friendModel.user1ID == userId ? friendModel.user2ID : friendModel.user1ID
                            
                            dispatchGroup.enter()
                            self.fetchUserWithId(friendId) { result in
                                switch result {
                                case .success(let userModel):
                                    self.friends[friendId] = userModel
                                case .failure(let error):
                                    fetchError = error
                                }
                                dispatchGroup.leave()
                            }
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    if let error = fetchError {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    func sendFriendRequest(from user1ID: String, to user2ID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let friendRequest = FriendModel(id: UUID().uuidString, user1ID: user1ID, user2ID: user2ID, isRequested: true, isAccepted: false)
        db.collection("friends").document(friendRequest.id).setData(friendRequest.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func acceptFriendRequest(friendRequestId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("friends").document(friendRequestId).updateData([
            "isAccepted": true
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func rejectFriendRequest(friendRequestId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("friends").document(friendRequestId).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchUserWithId(_ id: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        db.collection("users").document(id).getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = documentSnapshot, document.exists {
                do {
                    if let data = document.data() {
                        let userModel = try Firestore.Decoder().decode(UserModel.self, from: data)
                        completion(.success(userModel))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse user model"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found"])))
            }
        }
    }
    
    func fetchIncomingFriendRequests(for userId: String, completion: @escaping (Result<[(FriendModel, UserModel)], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("friends")
            .whereField("user2ID", isEqualTo: userId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let dispatchGroup = DispatchGroup()
                    var friendRequestsWithUser: [(FriendModel, UserModel)] = []
                    var fetchError: Error?
                    
                    querySnapshot?.documents.forEach { document in
                        if let friendRequest = try? document.data(as: FriendModel.self) {
                            dispatchGroup.enter()
                            self.fetchUserWithId(friendRequest.user1ID) { result in
                                switch result {
                                case .success(let userModel):
                                    friendRequestsWithUser.append((friendRequest, userModel))
                                case .failure(let error):
                                    fetchError = error
                                }
                                dispatchGroup.leave()
                            }
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        if let error = fetchError {
                            completion(.failure(error))
                        } else {
                            completion(.success(friendRequestsWithUser))
                        }
                    }
                }
            }
    }


    func fetchSentFriendRequests(for userId: String, completion: @escaping (Result<[FriendModel], Error>) -> Void) {
        db.collection("friends")
            .whereField("user1ID", isEqualTo: userId)
            .whereField("isRequested", isEqualTo: true)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let sentRequests = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: FriendModel.self)
                    } ?? []
                    completion(.success(sentRequests))
                }
            }
    }
    func fetchFriends(for userId: String, completion: @escaping (Result<[UserModel], Error>) -> Void) {
        db.collection("friends")
            .whereField("isAccepted", isEqualTo: true)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let dispatchGroup = DispatchGroup()
                    var friends: [UserModel] = []
                    var fetchError: Error?
                    
                    querySnapshot?.documents.forEach { document in
                        if let friendModel = try? document.data(as: FriendModel.self) {
                            let friendId = friendModel.user1ID == userId ? friendModel.user2ID : friendModel.user1ID
                            
                            dispatchGroup.enter()
                            self.fetchUserWithId(friendId) { result in
                                switch result {
                                case .success(let userModel):
                                    friends.append(userModel)
                                case .failure(let error):
                                    fetchError = error
                                }
                                dispatchGroup.leave()
                            }
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        if let error = fetchError {
                            completion(.failure(error))
                        } else {
                            completion(.success(friends))
                        }
                    }
                }
            }
    }

}
