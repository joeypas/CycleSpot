//
//  Untitled.swift
//  CycleSpot
//
//  Created by Owen Saverio Romeo on 11/16/25.
//

import SwiftUI

struct FriendProfileView: View {
    let friend: Friend
    
    // Mock data — replace later with real friend data
    @State private var achievements: [Badge] = fakeBadges
    @State private var posts: [String] = [
        "Did a 25 mile ride today! Feeling great.",
        "Loving the new trail near Riverside.",
        "Training for the fall competition!",
        "Anyone riding this weekend?"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Profile Header
                VStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                        .padding(.top, 20)
                    
                    Text(friend.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                Divider()
                
                // Achievements Section (work on connecting this to Firebase)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Achievements")
                        .font(.headline)
                        .padding(.leading, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(achievements, id: \.self) { badge in
                                VStack {
                                    Image(systemName: badge.icon)
                                        .font(.largeTitle)
                                        .foregroundStyle(badge.color)
                                        .padding()
                                    
                                    Text(badge.name)
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Divider()
                
                // Post Section (work on connecting this to Firebase)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Posts")
                        .font(.headline)
                        .padding(.leading, 15) 
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(posts, id: \.self) { post in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(post)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray.opacity(0.2))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .navigationTitle(friend.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

