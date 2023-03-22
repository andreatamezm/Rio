//
//  FriendModel.swift
//  Rio
//
//  Created by Andrea Tamez on 3/21/23.
//

import Foundation

struct FriendModel: Identifiable, Codable {
    let id: String
    let user1ID: String
    let user2ID: String
    var isRequested: Bool // will be true if user has sent friend request
    var isAccepted: Bool // will be true if user accepts friend request

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "user1ID": user1ID,
            "user2ID": user2ID,
            "isRequested": isRequested,
            "isAccepted": isAccepted
        ]
    }
}
