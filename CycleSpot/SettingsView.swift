//
//  SettingsView.swift
//  CycleSpot
//
//  Created by Joseph Liotta on 10/15/25.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    
    @State var user: UserProfile? = nil
    @State private var selectedPhoto: PhotosPickerItem?
    @State var profileImage: Image? = nil
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let user = user {

                    // Profile Section
                    VStack(spacing: 12) {
                        
                        // Profile Image (placeholder or picked)
                        if let profileImage = profileImage {
                            profileImage
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                                .padding(.top, 20)
                        } else {
                            Image("profile_placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                                .padding(.top, 20)
                        }
                        
                        Text(user.displayname)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        // Photo Picker Button
                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .images
                        ) {
                            Text("Change Profile Pic")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .onChange(of: selectedPhoto) { newItem in
                            loadImage(item: newItem)
                        }
                    }
                    
                    Divider()
                    
                    // Badges Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Badges")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(fakeBadges, id: \.self) { badge in
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
                    
                }
                    
                    Divider()

                    // --- NEW: App Settings Row ---
                    NavigationLink(destination: AppSettingsScreen(notificationsEnabled: $notificationsEnabled)) {
                        HStack {
                            Label("App Settings", systemImage: "gearshape")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                    }

                    Divider()

                    // Old Sign Out removed (now inside AppSettingsScreen)
                }
            }
            .navigationTitle("Settings")
        }
    }

    // Load PhotosPicker image
    func loadImage(item: PhotosPickerItem?) {
        guard let item = item else { return }

        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                profileImage = Image(uiImage: uiImage)
            }
        }
    }
}

//
// Badge Model
//

struct Badge: Hashable {
    let name: String
    let icon: String
    let color: Color
}

let fakeBadges: [Badge] = [
    Badge(name: "Explorer", icon: "bicycle", color: .blue),
    Badge(name: "Speedster", icon: "flame", color: .orange),
    Badge(name: "Early Bird", icon: "sunrise", color: .yellow),
    Badge(name: "Night Rider", icon: "moon.stars", color: .purple)
]

//
// --- NEW: App Settings Screen ---
//

struct AppSettingsScreen: View {
    @Binding var notificationsEnabled: Bool

    var body: some View {
        VStack(spacing: 32) {

            // Notifications Toggle
            Toggle("Enable Notifications", isOn: $notificationsEnabled)
                .padding(.horizontal)

            // Privacy Row (same style)
            NavigationLink(destination: Text("Privacy Settings (Coming Soon)")) {
                HStack {
                    Label("Privacy", systemImage: "lock")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }

            Spacer()

            // Sign Out Button
            Button(role: .destructive) {
                // sign out logic here
            } label: {
                Text("Sign Out")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)

        }
        .navigationTitle("App Settings")
        .padding(.top)
    }
}

#Preview {
    //SettingsView(user: UserProfile(id: "test", displayname: "Username1"))
    SettingsView()
}
