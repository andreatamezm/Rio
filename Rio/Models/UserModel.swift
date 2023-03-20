//
//  UserModel.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import Foundation

// Represents a user with an email, username, and a collection of posts.
struct UserModel: Identifiable, Codable {
    let id: String
    let email: String
    let username: String
    
    // A collection of posts authored by the user, keyed by post ID.
    var posts: [String: PostModel] 

    // Returns a dictionary representation of the user object.
    func toDictionary() -> [String: Any] {
        return [
            "userID": id,
            "email": email,
            "username": username
        ]
    }
}
