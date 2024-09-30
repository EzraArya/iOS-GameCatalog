import SwiftUI

struct FavoriteView: View {
    @State private var selectedButton: FavoriteFilter = .games
    @FetchRequest(sortDescriptors: [])
    private var favoriteGamesResult: FetchedResults<FavoriteGame>
    @FetchRequest(sortDescriptors: [])
    private var favoriteDevelopersResult: FetchedResults<FavoriteDeveloper>
    @FetchRequest(sortDescriptors: [])
    private var favoriteCreatorsResult: FetchedResults<FavoriteCreator>
    @EnvironmentObject var navigationState: NavigationState
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    FilterView(buttonIcon: "gamecontroller", action: {
                        withAnimation(.linear(duration: 0.2)) {
                            selectedButton = .games
                        }
                    }, isSelected: selectedButton == .games)
                    FilterView(buttonIcon: "person.2", action: {
                        withAnimation(.linear(duration: 0.2)) {
                            selectedButton = .creators
                        }
                    }, isSelected: selectedButton == .creators)
                    FilterView(buttonIcon: "person.3", action: {
                        withAnimation(.linear(duration: 0.2)) {
                            selectedButton = .developers
                        }
                    }, isSelected: selectedButton == .developers)
                }
                .frame(maxHeight: 60)
                Divider()
                List {
                    switch selectedButton {
                    case .games:
                        if favoriteGamesResult.isEmpty {
                            Text("No Favorited Games")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(favoriteGamesResult) { game in
                                NavigationLink(value: game.id) {
                                    HStack {
                                        AsyncImage(url: URL(string: game.gamePhoto ?? "https://t3.ftcdn.net/jpg/01/65/63/94/360_F_165639425_kRh61s497pV7IOPAjwjme1btB8ICkV0L.jpg")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.gray, lineWidth: 2)
                                                )
                                                .shadow(radius: 2)
                                        }
                                    placeholder: {
                                        ProgressView()
                                    }
                                        VStack(alignment: .leading) {
                                            Text(game.name ?? "Unknown Game")
                                                .font(.title2)
                                            Spacer()
                                            HStack {
                                                StarRatingView(rating: game.ratings)
                                                Text("\(game.ratings.formatted())")
                                                    .foregroundStyle(.black)
                                            }
                                            Text(game.releasedDate ?? "No Release Date")
                                            Spacer()
                                        }
                                        .padding(.vertical, 10)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    case .developers:
                        if favoriteDevelopersResult.isEmpty {
                            Text("No Favorited Developers")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(favoriteDevelopersResult) { developer in
                                NavigationLink(value: developer.id) {
                                    HStack {
                                        AsyncImage(url: URL(string: developer.gamePhoto ?? "https://t3.ftcdn.net/jpg/01/65/63/94/360_F_165639425_kRh61s497pV7IOPAjwjme1btB8ICkV0L.jpg")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.gray, lineWidth: 2)
                                                )
                                                .shadow(radius: 2)
                                        }
                                    placeholder: {
                                        ProgressView()
                                    }
                                        VStack(alignment: .leading) {
                                            Text(developer.name ?? "Unknown Developer")
                                                .font(.title2)
                                            Text("\(developer.gameCount) games")
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                    case .creators:
                        if favoriteCreatorsResult.isEmpty {
                            Text("No Favorited Creators")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(favoriteCreatorsResult) { creator in
                                NavigationLink(value: creator.id) {
                                    HStack {
                                        AsyncImage(url: URL(string: creator.image ?? "https://t3.ftcdn.net/jpg/01/65/63/94/360_F_165639425_kRh61s497pV7IOPAjwjme1btB8ICkV0L.jpg")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.gray, lineWidth: 2)
                                                )
                                                .shadow(radius: 2)
                                        }
                                    placeholder: {
                                        ProgressView()
                                    }
                                        VStack(alignment: .leading) {
                                            Text(creator.name ?? "Unknown Creator")
                                                .font(.title2)
                                            Text("\(creator.gameCount) games")
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .padding(.horizontal)
            .navigationTitle("Favorites")
            .navigationDestination(for: Int64.self) { id in
                switch selectedButton {
                case .games:
                    if favoriteGamesResult.first(where: { $0.id == id }) != nil {
                        DetailView(id: Int(id), filter: .games)
                    }
                case .developers:
                    if favoriteDevelopersResult.first(where: { $0.id == id }) != nil {
                        DetailView(id: Int(id), filter: .developers)
                    }
                case .creators:
                    if favoriteCreatorsResult.first(where: { $0.id == id }) != nil {
                        DetailView(id: Int(id), filter: .creators)
                    }
                }
            }
        }
    }
}

#Preview {
    FavoriteView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.persistenceContainer.viewContext)
        .environmentObject(NavigationState())

}

enum FavoriteFilter {
    case games, developers, creators
}
