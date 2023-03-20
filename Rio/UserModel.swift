//
//  UserModel.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import Foundation

struct UserModel: Identifiable, Codable {
    var id: String
    var email: String
    var username: String
    var posts: [String: PostModel] // Add this property to store posts in a dictionary where the key is the postId

    func toDictionary() -> [String: Any] {
        return [
            "userID": id,
            "email": email,
            "username": username
        ]
    }
}
