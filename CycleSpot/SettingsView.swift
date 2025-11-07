//

//  SettingsView.swift
//  CycleSpot
//
//  Created by Joseph Liotta on 10/15/25.
//



import SwiftUI
struct SettingsView: View {

    @State private var showingProfileOptions = false
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // Profile
                    VStack(spacing: 12) {
                        Image("profile_placeholder") // Replace with your image later
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            .shadow(radius: 3)
                            .padding(.top, 20)

                        Text("Username1")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Button(action: {
                            showingProfileOptions.toggle()
                        }) {

                            Text("Change Profile Pic")
                                .font(.subheadline)
                                .foregroundColor(.blue)

                        }

                        .sheet(isPresented: $showingProfileOptions) {

                            VStack {
                                Text("Profile Change Options")

                                    .font(.headline)
                                Spacer()
                                Button("Close") {
                                    showingProfileOptions = false
                                }
                                .padding()
                            }
                            .presentationDetents([.medium])
                        }
                    }
                
                    Divider()
                    
                    // Badges
                    
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
                                            //.background(Color(.systemGray6))
                                            .clipShape(Circle())
                                        
                                        Text(badge.name)
                                            .font(.caption)

                                    }

                                }

                            }
                            .padding(.horizontal)
                        }
                    }

                    Divider()

                    // App Settings
                    VStack(alignment: .leading, spacing: 16) {
                        Text("App Settings")
                            .font(.headline)

                        Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        

                        NavigationLink(destination: Text("Privacy Settings (Coming Soon)")) {
                            HStack {
                                Label("Privacy", systemImage: "lock")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)

                    Divider()
                    
                    // Sign out button
                    Button(action: {
                        // *Sign out logic will go here*

                    }) {

                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)

                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Settings")
        }
    }
}


// Badge Examples
struct Badge: Hashable {
    let name: String
    let icon: String
    let color: Color

}

let fakeBadges: [Badge] = [
    Badge(name: "Explorer", icon: "bicycle", color: .blue),
    Badge(name: "Speedster", icon: "flame", color: .orange),
    Badge(name: "Early Bird", icon: "sunrise", color: .yellow),
    Badge(name: "Night Rider", icon: "moon.stars", color: .purple)]

#Preview {
    SettingsView()
}
