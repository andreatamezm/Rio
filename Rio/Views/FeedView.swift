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


    
    var body: some View {
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
                                .foregroundColor(Color("ButtonGreen"))
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
                
                if let image = postData.imagesForDays[postData.dateFormatter.string(from: Date())] {
                    ScrollView {
                        VStack(spacing: 0) {
                            Image(uiImage: postData.imagesForDays[postData.dateFormatter.string(from: Date())]!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: UIScreen.main.bounds.width)
                            
                            HStack {
                                Text(postData.captionsForDays[postData.dateFormatter.string(from: Date())] ?? "")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding()
                                
                                Spacer()
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .shadow(radius: 5)
                    }
                    .padding(.top, 20)
                    Spacer()
                }
        }
    }
}
