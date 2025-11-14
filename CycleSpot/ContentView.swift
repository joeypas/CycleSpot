import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @StateObject private var rackView = BikeRackView()
    var body: some View {
        TabView {
            MapTabView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                    
            FriendsView()
                .tabItem {
                    Label("Friends", systemImage: "person")
                }
                    
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
