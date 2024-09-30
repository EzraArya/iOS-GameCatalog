import SwiftUI

class NavigationState: ObservableObject {
    @Published var path = NavigationPath()
}
