//
//  ImageData.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

// MARK: - Custom Errors

enum SignInError: Error {
    case failedToGetUserId
}

enum ImageError: Error {
    case failedToCompressImage
    case failedToLoadImage
}


// An observable object responsible for handling image data and interacting with Firebase services.
class ImageData: ObservableObject {
    @Published var imagesForDays: [String: UIImage] = [:]
    @Published var currentUserId: String?
    
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: - Public Methods
    
    func updateImageForDay(day: String, image: UIImage) {
        imagesForDays[day] = image
        print("Updated image for day: \(day), imagesForDays: \(imagesForDays)")
        objectWillChange.send()
    }
    
    func createPost(image: UIImage, date: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = currentUserId else {
            completion(.failure(SignInError.failedToGetUserId))
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateKey = dateFormatter.string(from: date)
        
        // Create a key that includes the user's ID
        let userDateKey = "\(userId)_\(dateKey)"
        
        // Upload the image to Firebase Storage
        uploadImageToStorage(image: image, userId: userId, dateKey: dateKey) { result in
            switch result {
            case .success(let imageURL):
                _ = PostModel(id: UUID().uuidString, imageURL: imageURL, date: date)
                
                // Save the post to the Firestore database
                self.savePostToFirestore(imageURL: imageURL, date: date, userId: userId)

                
                // Update the imagesForDays dictionary
                DispatchQueue.main.async {
                    self.imagesForDays[userDateKey] = image
                }
                
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchPostsForUser(userId: String, completion: @escaping (Result<[String: PostModel], Error>) -> Void) {
        guard let userId = currentUserId else { return }

        db.collection("users").document(userId).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                do {
                    if let data = document.data() {
                        let userModel = try Firestore.Decoder().decode(UserModel.self, from: data)
                        completion(.success(userModel.posts))
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

    func updateImagesForDays(posts: [PostModel]) {
        for post in posts {
            loadImage(from: post.imageURL) { postImage in
                if let postImage = postImage {
                    DispatchQueue.main.async {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateString = dateFormatter.string(from: post.date)
                        self.imagesForDays[dateString] = postImage
                    }
                }
            }
        }
    }
    
    func fetchImagesForUser(posts: [String: PostModel], completion: @escaping (Result<Void, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var fetchError: Error?
        
        // Initialize imagesForDays with nil values for all days
        initializeImagesForDays()
        
        // Fetch images for days with non-nil values
        for (_, post) in posts {
            dispatchGroup.enter()
            loadImage(from: post.imageURL) { image in
                if let image = image {
                    let dateString = self.dateFormatter.string(from: post.date)
                    self.imagesForDays[dateString] = image
                } else {
                    fetchError = ImageError.failedToLoadImage
                }
                dispatchGroup.leave()
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

    private func initializeImagesForDays() {
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: startDate)!
        var currentDate = startDate
        while currentDate <= endDate {
            let dateString = dateFormatter.string(from: currentDate)
            imagesForDays[dateString] = nil
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
    }

    
    func listenToPostsForUser(userId: String, completion: @escaping (Result<[String: PostModel], Error>) -> Void) {
        db.collection("users").document(userId).addSnapshotListener { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = documentSnapshot, document.exists {
                do {
                    if let data = document.data() {
                        let userModel = try Firestore.Decoder().decode(UserModel.self, from: data)
                        completion(.success(userModel.posts))
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



    // MARK: - Private Methods
    
    private func uploadImageToStorage(image: UIImage, userId: String, dateKey: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(ImageError.failedToCompressImage))
            return
        }
        
        let storageRef = storage.reference().child("images/\(userId)/\(dateKey).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url.absoluteString))
                    }
                }
            }
        }
    }

    private func savePostToFirestore(imageURL: String, date: Date, userId: String) {
        let newPost = PostModel(id: UUID().uuidString, imageURL: imageURL, date: date)

        // Update the user document with the new post
        db.collection("users").document(userId).updateData([
            "posts.\(newPost.id)": newPost.asDictionary()
        ]) { error in
            if let error = error {
                print("Error saving post: \(error)")
            }
        }
    }
    
    private func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
            guard let imageURL = URL(string: url) else {
                print("Invalid image URL")
                completion(nil)
                return
            }

            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data, let image = UIImage(data: data) else {
                    print("Unable to convert data to image")
                    completion(nil)
                    return
                }

                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
}
