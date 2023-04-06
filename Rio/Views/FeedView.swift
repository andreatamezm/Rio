//
//  FeedView.swift
//  Rio
//
//  Created by Andrea Tamez on 3/21/23.
//

import SwiftUI


struct FeedView: View {
    @EnvironmentObject var postData: PostData
    var currentDate = Date()
    @State private var isShowingAddFriends = false
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var friendsList: FriendsList
    @State private var friendsPosts: [(postId: String, username: String, image: UIImage, caption: String?)] = []
    @State private var refreshId = UUID()

    private func findFriend(for postId: String) -> UserModel? {
        for friend in friendsList.friends.values {
            if friend.posts.keys.contains(postId) {
                print("Friend found for postId: \(postId) - \(friend.username)") // Debugging
                return friend
            }
        }
        print("No friend found for postId: \(postId)") // Debugging
        return nil
    }



    private func friendsPostsView() -> some View {
        VStack(spacing: 60) {
            ForEach(friendsPosts, id: \.postId) { post in
                
                    
                
                
                VStack(spacing: 0) {
                    
                    ZStack {
                        Image(uiImage: post.image)
                            .resizable()
                            .clipped()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width / 1.1, height: (UIScreen.main.bounds.width / 1.1) * 16 / 9)
                        
                        VStack {
                            HStack {
                                Text(post.username)
                                    .padding(5)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color("AccentColor"))
                                    .background(Color("CaptionBackground"))
                                    .cornerRadius(10)
                                    .padding([.top, .leading], 10)
                                
                                Spacer()
                            }
                            
                            Spacer()
                            
                            Text(post.caption ?? "")
                                .padding(5)
                                .font(.system(size: 18, weight: .medium))
                                .background(Color("CaptionBackground"))
                                .cornerRadius(10)
                                .foregroundColor(Color("CaptionText"))
                                .padding(.bottom, 10)
                        }
                       
                    }
                }
                    .cornerRadius(12)
                    .frame(width: UIScreen.main.bounds.width / 1.1, height: (UIScreen.main.bounds.width / 1.1) * 16 / 9)
                }
            }

    }


    var body: some View {
        NavigationView {
            ZStack {
                Image("MainAppBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    // Button
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.isShowingAddFriends = true
                            }) {
                                Image(systemName: "person.badge.plus")
                                    .font(.title)
                                    .foregroundColor(Color("AccentColor"))
                                    .imageScale(.medium)
                            }
                            .padding(.trailing, 20)
                            .sheet(isPresented: $isShowingAddFriends) {
                                AddFriendsView()
                                    .environmentObject(authManager)
                                    .environmentObject(friendsList)
                            }
                        }
                    }
                    
                    // Posts
                    ScrollView {
                        VStack(spacing: 40) {
                            if let image = postData.imagesForDays[postData.dateFormatter.string(from: Date())] {
                                
                                VStack(spacing: 0) {
                                    ZStack {
                                        
                                        Image(uiImage: postData.imagesForDays[postData.dateFormatter.string(from: Date())]!)
                                            .resizable()
                                            .clipped()
                                            .scaledToFill()
                                            .frame(width: UIScreen.main.bounds.width / 1.1, height: ((UIScreen.main.bounds.width / 1.1) * 16 / 9) - 30)

                                        VStack {
                                            
                                            Spacer()
                                            
                                            Text(postData.captionsForDays[postData.dateFormatter.string(from: Date())] ?? "")
                                                .padding(5)
                                                .font(.system(size: 18, weight: .medium))
                                                .background(Color("CaptionBackground"))
                                                .cornerRadius(10)
                                                .foregroundColor(Color("CaptionText"))
                                                .padding(.bottom, 10)
                                        }
                                        
                                        
                                    }
                                    .cornerRadius(12)
                                    .frame(width: UIScreen.main.bounds.width / 1.1, height: ((UIScreen.main.bounds.width / 1.1) * 16 / 9) - 30)
                                }
                                .padding([.top, .bottom], 5)
                            }
                            
                            friendsPostsView()
                        }
                        
                        
                    }
                    
                    .id(refreshId) // Update this line
                }
                .padding(.top, 120)
                //.padding(.bottom, 35)
                
                .onAppear {
                    if let userId = authManager.user?.uid {
                        friendsList.fetchFriendsPostsForCurrentDay(userId: userId, postData: postData) { result in
                            switch result {
                            case .success(let fetchedFriendsPosts):
                                friendsPosts = fetchedFriendsPosts
                                refreshId = UUID() // Add this line
                                print("Fetched friends' posts: \(fetchedFriendsPosts)") // Debugging
                            case .failure(let error):
                                print("Error fetching friends' posts: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
}
