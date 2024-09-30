import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var games = [Game]()
    @Published var developers = [Developer]()
    @Published var creators = [Creator]()
    @Published var selectedButton: ButtonFilter = .games
    @Published var isFetching: Bool = false
    var title: String {
        switch selectedButton {
        case .games:
            return "Games List"
        case .developers:
            return "Developers List"
        case .creators:
            return "Creators List"
        }
    }
    enum ButtonFilter {
        case games, developers, creators
    }
    func fetchListData(for filter: ButtonFilter) async {
        isFetching = true
        defer { isFetching = false }
        let urlString: String
        switch filter {
        case .games:
            urlString = "https://api.rawg.io/api/games?key=\(APIKey)"
        case .developers:
            urlString = "https://api.rawg.io/api/developers?key=\(APIKey)"
        case .creators:
            urlString = "https://api.rawg.io/api/creators?key=\(APIKey)"
        }
        print("Fetching data from URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Server error")
                return
            }
            switch filter {
            case .games:
                let decodedResponse = try JSONDecoder().decode(Games.self, from: data)
                print("Decoded Response: \(decodedResponse)")
                self.games = decodedResponse.results
            case .developers:
                let decodedResponse = try JSONDecoder().decode(Developers.self, from: data)
                print("Decoded Response: \(decodedResponse)")
                self.developers = decodedResponse.results
            case .creators:
                let decodedResponse = try JSONDecoder().decode(Creators.self, from: data)
                print("Decoded Response: \(decodedResponse)")
                self.creators = decodedResponse.results
            }
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
    }
    func fetchSearchData(for filter: ButtonFilter, name: String) async {
        let urlString: String
        let encodedName = name.replacingOccurrences(of: " ", with: "-")
                              .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        switch filter {
        case .games:
            urlString = "https://api.rawg.io/api/games?search=\(encodedName)&key=\(APIKey)"
        case .developers:
            urlString = "https://api.rawg.io/api/developers?search=\(encodedName)&key=\(APIKey)"
        case .creators:
            urlString = "https://api.rawg.io/api/creators?search=\(encodedName)&key=\(APIKey)"
        }
        print("Fetching data from URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Server error")
                return
            }
            switch filter {
            case .games:
                let decodedResponse = try JSONDecoder().decode(Games.self, from: data)
                print("Decoded Response: \(decodedResponse)")
                self.games = decodedResponse.results.sorted { $0.ratingGame > $1.ratingGame }
            case .developers:
                let decodedResponse = try JSONDecoder().decode(Developers.self, from: data)
                print("Decoded Response: \(decodedResponse)")
                self.developers = decodedResponse.results
            case .creators:
                let decodedResponse = try JSONDecoder().decode(Creators.self, from: data)
                print("Decoded Response: \(decodedResponse)")
                self.creators = decodedResponse.results
            }
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
    }
}
