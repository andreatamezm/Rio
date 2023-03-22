//
//  AddFriendsView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/21/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth


struct AddFriendsView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var friendsList: FriendsList
    @State private var allUsers: [UserModel] = []
    @State private var incomingFriendRequestsWithUser: [(FriendModel, UserModel)] = []
    @State private var sentFriendRequests: [String] = []
    @State private var friends: [UserModel] = [] // Add this line


    // Add this helper function
    private func fetchSentFriendRequests() {
        guard let currentUserId = authManager.userModel?.id else { return }
        friendsList.fetchSentFriendRequests(for: currentUserId) { result in
            switch result {
            case .success(let sentRequests):
                sentFriendRequests = sentRequests.map { $0.user2ID }
            case .failure(let error):
                print("Error fetching sent friend requests: \(error.localizedDescription)")
            }
        }
    }
    
    var friendRequests: [(FriendModel, UserModel)] {
        incomingFriendRequestsWithUser.filter { $0.0.isRequested && !$0.0.isAccepted }
    }
    
    var body: some View {
        VStack {
            Text("Add Friends")
                .font(.largeTitle)
                .bold()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Friend Requests")
                        .font(.title)
                        .bold()
                    
                    ForEach(friendRequests, id: \.0.id) { (request, user) in
                        HStack {
                            Text(user.username)
                            
                            Spacer()
                            
                            Button(action: {
                                acceptFriendRequest(request: request)
                            }) {
                                Text("Accept")
                            }
                            
                            Button(action: {
                                rejectFriendRequest(request: request)
                            }) {
                                Text("Reject")
                            }
                        }
                    }
                    
                    Text("All Users")
                        .font(.title)
                        .bold()
                    
                    ForEach(allUsers.filter({ user in
                        !sentFriendRequests.contains(user.id)
                    }), id: \.id) { user in
                        HStack {
                            Text(user.username)

                            Spacer()

                            Button(action: {
                                sendFriendRequest(to: user)
                            }) {
                                Text("Add")
                            }
                        }
                    }
                    
                    Text("Friends")
                        .font(.title)
                        .bold()

                    ForEach(friends, id: \.id) { friend in
                        Text(friend.username)
                    }

                }
            }
            .padding()
        }
        .onAppear {
            fetchAllUsers()
            fetchIncomingFriendRequests()
            fetchSentFriendRequests()
            fetchFriends()

        }
    }
    
    private func fetchAllUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
            } else {
                allUsers = querySnapshot?.documents.compactMap { document in
                    guard let user = try? document.data(as: UserModel.self) else { return nil }
                    return user.id != authManager.userModel?.id ? user : nil
                } ?? []
            }
        }
    }
    
    private func sendFriendRequest(to user: UserModel) {
        guard let currentUserId = authManager.userModel?.id else { return }
        friendsList.sendFriendRequest(from: currentUserId, to: user.id) { result in
            switch result {
            case .success:
                print("Friend request sent successfully.")
            case .failure(let error):
                print("Error sending friend request: \(error.localizedDescription)")
            }
        }
    }
    
    private func acceptFriendRequest(request: FriendModel) {
        friendsList.acceptFriendRequest(friendRequestId: request.id) { result in
            switch result {
            case .success:
                print("Friend request accepted successfully.")
                // Remove the friend request from the incomingFriendRequestsWithUser array
                if let index = incomingFriendRequestsWithUser.firstIndex(where: { $0.0.id == request.id }) {
                    incomingFriendRequestsWithUser.remove(at: index)
                }
            case .failure(let error):
                print("Error accepting friend request: \(error.localizedDescription)")
            }
        }
    }
    
    private func rejectFriendRequest(request: FriendModel) {
        friendsList.rejectFriendRequest(friendRequestId: request.id) { result in
            switch result {
            case .success:
                print("Friend request rejected successfully.")
                // Remove the friend request from the incomingFriendRequestsWithUser array
                if let index = incomingFriendRequestsWithUser.firstIndex(where: { $0.0.id == request.id }) {
                    incomingFriendRequestsWithUser.remove(at: index)
                }
            case .failure(let error):
                print("Error rejecting friend request: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchIncomingFriendRequests() {
        guard let currentUserId = authManager.userModel?.id else { return }
        friendsList.fetchIncomingFriendRequests(for: currentUserId) { result in
            switch result {
            case .success(let friendRequestsWithUser):
                incomingFriendRequestsWithUser = friendRequestsWithUser
            case .failure(let error):
                print("Error fetching incoming friend requests: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchFriends() {
        guard let currentUserId = authManager.userModel?.id else { return }
        friendsList.fetchFriends(for: currentUserId) { result in
            switch result {
            case .success(let friendsList):
                friends = friendsList
            case .failure(let error):
                print("Error fetching friends list: \(error.localizedDescription)")
            }
        }
    }

    // The rest of the friend request management functions go here (sendFriendRequest, acceptFriendRequest, rejectFriendRequest)
}
