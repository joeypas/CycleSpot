//
//  UserProfile.swift
//  CycleSpot
//
//  Created by Joseph Liotta on 11/19/25.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Identifiable, Codable {
    @DocumentID var id: String?
    var displayname: String
    var profileImagePath: URL?
    var pinnedLocations: [String] = []
    var badges: [String] = []
    var reviews: [Review] = []
}

struct Review: Codable, Identifiable {
    @DocumentID var id: String?
    var comment: String
    var locationId: String
    var rating: Int
    @ServerTimestamp var timestamp: Date?
}
