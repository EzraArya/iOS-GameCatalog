import SwiftUI

struct ContentView: View {
    @StateObject private var navigationState = NavigationState()
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            FavoriteView()
                .tabItem {
                    Label("Favorite", systemImage: "heart")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .environmentObject(navigationState)
    }
}

#Preview {
    ContentView()
}
