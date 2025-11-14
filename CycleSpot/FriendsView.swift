//
//  FriendsView.swift
//  CycleSpot
//
//  Created by Joseph Liotta on 10/15/25.
//

import SwiftUI

struct Friend: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct FriendsView: View {
    
    private let friends: [Friend] = [
        Friend(name: "Owen Romeo"),
        Friend(name: "Joe Liotta"),
        Friend(name: "Remy Roel"),
        Friend(name: "Kiera Hanson")
    ]
    
    var body: some View {
        NavigationStack {
            List(friends) { friend in
                NavigationLink(value: friend) {
                    Label(friend.name, systemImage: "person.circle")
                }
            }
            .navigationDestination(for: Friend.self) { friend in
                FriendProfileView(friend: friend)
            }
            .navigationTitle("Friends")
        }
    }
}

#Preview {
    FriendsView()
}
