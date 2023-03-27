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
    @State private var searchText: String = ""
    
    var filteredUsers: [UserModel] {
        if searchText.isEmpty {
            return allUsers
        } else {
            return allUsers.filter { user in
                user.username.lowercased().contains(searchText.lowercased())
            }
        }
    }

    
    var friendRequests: [(FriendModel, UserModel)] {
        incomingFriendRequestsWithUser.filter { $0.0.isRequested && !$0.0.isAccepted }
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            NavigationView {
                ZStack {
                    Image("MainAppBackground")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    
                    VStack {
                                            Text("Add Friends")
                                                .font(.largeTitle)
                                                .bold()
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                
                                
                                if !friendRequests.isEmpty {
                                    
                                    Text("Friend Requests")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(Color("AccentColor"))
                                    
                                    
                                    VStack {
                                        ForEach(friendRequests, id: \.0.id) { (request, user) in
                                            HStack {
                                                Text(user.username)
                                                    .padding(2)
                                                    .foregroundColor(Color("CaptionText"))

                                                
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
                                    }
                                    .padding(5)
                                    .background(Color("CaptionBackground"))
                                    .cornerRadius(10)

                                }
                                
                                if !friends.isEmpty {
                                    
                                    Text("Friends")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(Color("AccentColor"))
                                    
                                    
                                    VStack {
                                        ForEach(friends, id: \.id) { friend in
                                            HStack {
                                                Text(friend.username)
                                                    .padding(2)
                                                    .foregroundColor(Color("CaptionText"))
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    removeFriendship(with: friend)
                                                }) {
                                                    Text("Delete")
                                                }
                                            }
                                        }
                                    
                                }
                                .padding(5)
                                .background(Color("CaptionBackground"))
                                .cornerRadius(10)
                                }
                                
                                
                                
                                Text("All Users")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(Color("AccentColor"))
                                
                                TextField("Search users", text: $searchText)
                                    .padding(5)
                                    .background(Color("SearchBackground"))
                                    .foregroundColor(Color("CaptionBackground"))
                                    .cornerRadius(10)
                                
                                VStack {
                                    ForEach(filteredUsers, id: \.id) { user in
                                        if !incomingFriendRequestsWithUser.contains(where: { $0.1.id == user.id }) &&
                                            !friends.contains(where: { $0.id == user.id }) &&
                                            (authManager.userModel?.id != user.id) {
                                            HStack {
                                                Text(user.username)
                                                    .padding(2)
                                                    .foregroundColor(Color("CaptionText"))
                                                
                                                Spacer()
                                                
                                                if sentFriendRequests.contains(user.id) {
                                                    Button(action: {
                                                        removeFriendship(with: user)
                                                        if let index = sentFriendRequests.firstIndex(of: user.id) {
                                                            sentFriendRequests.remove(at: index)
                                                        }
                                                    }) {
                                                        Text("Requested")
                                                    }
                                                } else {
                                                    Button(action: {
                                                        sendFriendRequest(to: user)
                                                        sentFriendRequests.append(user.id)
                                                    }) {
                                                        Text("Add")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            
                            .padding(5)
                            .background(Color("CaptionBackground"))
                            .cornerRadius(10)
                                
                                
                                
                                
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
            }
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
    
    private func acceptFriendRequest(request: FriendModel) {
        friendsList.acceptFriendRequest(friendRequestId: request.id) { result in
            switch result {
            case .success:
                print("Friend request accepted successfully.")
                // Remove the friend request from the incomingFriendRequestsWithUser array
                if let index = incomingFriendRequestsWithUser.firstIndex(where: { $0.0.id == request.id }) {
                    let acceptedFriend = incomingFriendRequestsWithUser[index].1
                    incomingFriendRequestsWithUser.remove(at: index)
                    friends.append(acceptedFriend)
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
                    let rejectedUserId = incomingFriendRequestsWithUser[index].1.id
                    incomingFriendRequestsWithUser.remove(at: index)
                    if let sentRequestIndex = sentFriendRequests.firstIndex(of: rejectedUserId) {
                        sentFriendRequests.remove(at: sentRequestIndex)
                    }
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
            case .success(let friends):
                self.friends = friends
            case .failure(let error):
                print("Error fetching friends list: \(error.localizedDescription)")
            }
        }
    }

    
    private func removeFriendship(with friend: UserModel) {
        guard let currentUserId = authManager.userModel?.id else { return }
        friendsList.removeFriendshipBetween(user1ID: currentUserId, user2ID: friend.id) { result in
            switch result {
            case .success:
                print("Friendship removed successfully.")
                // Remove the friend from the friends array
                if let index = friends.firstIndex(where: { $0.id == friend.id }) {
                    friends.remove(at: index)
                    sentFriendRequests.removeAll { $0 == friend.id }
                }
                self.fetchAllUsers()
            case .failure(let error):
                print("Error removing friendship: \(error.localizedDescription)")
            }
        }
    }



    // The rest of the friend request management functions go here (sendFriendRequest, acceptFriendRequest, rejectFriendRequest)
}
