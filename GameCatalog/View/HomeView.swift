import SwiftUI

struct HomeView: View {
    @StateObject private var homeData = HomeViewModel()
    @State private var searchText = ""
    @EnvironmentObject var navigationState: NavigationState
    var body: some View {
        NavigationStack(path: $navigationState.path) {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    FilterView(buttonIcon: "gamecontroller", action: {
                        withAnimation(.linear(duration: 0.2)) {
                            homeData.selectedButton = .games
                            Task {
                                await homeData.fetchListData(for: .games)
                            }
                        }
                    }, isSelected: homeData.selectedButton == .games)
                    FilterView(buttonIcon: "person.2", action: {
                        withAnimation(.linear(duration: 0.2)) {
                            homeData.selectedButton = .creators
                            Task {
                                await homeData.fetchListData(for: .creators)
                            }
                        }
                    }, isSelected: homeData.selectedButton == .creators)
                    FilterView(buttonIcon: "person.3", action: {
                        withAnimation(.linear(duration: 0.2)) {
                            homeData.selectedButton = .developers
                            Task {
                                await homeData.fetchListData(for: .developers)
                            }
                        }
                    }, isSelected: homeData.selectedButton == .developers)
                }
                .frame(maxHeight: 60)
                Divider()
                if homeData.isFetching {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    List {
                        switch homeData.selectedButton {
                        case .games:
                            ForEach(homeData.games, id: \.id) { game in
                                NavigationLink(value: game) {
                                    HStack {
                                        AsyncImage(url: URL(string: game.gamePhoto)) { image in
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
                                            Text(game.name)
                                                .font(.title2)
                                            Spacer()
                                            HStack {
                                                StarRatingView(rating: game.ratingGame)
                                                Text("\(game.ratingGame.formatted())")
                                                    .foregroundStyle(.black)
                                            }
                                            Text(game.releasedDate)
                                            Spacer()
                                        }
                                        .padding(.vertical, 10)
                                        Spacer()
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                        case .developers:
                            ForEach(homeData.developers, id: \.id) { developer in
                                NavigationLink(value: developer) {
                                    HStack {
                                        AsyncImage(url: URL(string: developer.gamePhoto)) { image in
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
                                            Text(developer.name)
                                                .font(.title2)
                                            Text("\(developer.gameCount) games")
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        case .creators:
                            ForEach(homeData.creators, id: \.id) { creator in
                                NavigationLink(value: creator) {
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
                                            Text(creator.name)
                                                .font(.title2)
                                            Text("\(creator.gameCount) games")
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .searchable(text: $searchText)
            .textInputAutocapitalization(.never)
            .onChange(of: searchText) {
                Task {
                    if !searchText.isEmpty && searchText.count > 3 {
                        await homeData.fetchSearchData(for: homeData.selectedButton, name: searchText)
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle(homeData.title)
            .task {
                await homeData.fetchListData(for: homeData.selectedButton)
            }
            .navigationDestination(for: Game.self) { game in
                DetailView(id: game.id, filter: .games)
            }
            .navigationDestination(for: Developer.self) { developer in
                DetailView(id: developer.id, filter: .developers)
            }
            .navigationDestination(for: Creator.self) { creator in
                DetailView(id: creator.id, filter: .creators)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationState())
}
