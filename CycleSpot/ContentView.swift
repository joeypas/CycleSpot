import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Map", systemImage: "map") {
                MapView()
            }
            Tab("Friends", systemImage: "person") {
                FriendsView()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
