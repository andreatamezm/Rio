//
//  PostModel.swift
//  Rio
//
//  Created by Andrea Tamez on 3/20/23.
//

import Foundation
import FirebaseFirestore

struct PostModel: Identifiable, Codable {
    var id: String
    var imageURL: String
    var date: Date

    func asDictionary() -> [String: Any] {
        return [
            "id": id,
            "imageURL": imageURL,
            "date": Timestamp(date: date)
        ]
    }
}
