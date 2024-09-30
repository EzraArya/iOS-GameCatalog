import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationState: NavigationState
    @State private var isFavorited: Bool?
    init(id: Int, filter: HomeViewModel.ButtonFilter) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(id: id, filter: filter))
    }
    var body: some View {
        VStack {
            if let content = viewModel.content {
                DetailContentView(content: content)
            } else {
                ProgressView("Loading...")
            }
        }
        .padding(.horizontal)
        .navigationTitle(viewModel.title)
        .task {
            await viewModel.fetchDetails()
            updateFavoritedStatus()
        }
        .toolbar {
            Button(action: {
                guard let content = viewModel.content else { return }
                if isFavorited == true {
                    switch viewModel.filter {
                    case .games:
                        if let game = content.game {
                            FavoriteServices.removeGameFromFavorites(gameID: game.id)
                        }
                    case .developers:
                        if let developer = content.developer {
                            FavoriteServices.removeDeveloperFromFavorites(developerID: developer.id)
                        }
                    case .creators:
                        if let creator = content.creator {
                            FavoriteServices.removeCreatorFromFavorites(creatorID: creator.id)
                        }
                    }
                } else {
                    switch viewModel.filter {
                    case .games:
                        if let game = content.game {
                            FavoriteServices.saveFavoriteGame(game)
                        }
                    case .developers:
                        if let developer = content.developer {
                            FavoriteServices.saveFavoriteDeveloper(developer)
                        }
                    case .creators:
                        if let creator = content.creator {
                            FavoriteServices.saveFavoriteCreator(creator)
                        }
                    }
                }
                isFavorited?.toggle()
            }) {
                Image(systemName: isFavorited == true ? "heart.fill" : "heart")
                    .foregroundColor(isFavorited == true ? .red : .gray)
            }
        }
    }
    private func updateFavoritedStatus() {
        guard let content = viewModel.content else { return }
        switch viewModel.filter {
        case .games:
            if let game = content.game {
                isFavorited = FavoriteServices.isGameFavorited(gameID: game.id)
            }
        case .developers:
            if let developer = content.developer {
                isFavorited = FavoriteServices.isDeveloperFavorited(developerID: developer.id)
            }
        case .creators:
            if let creator = content.creator {
                isFavorited = FavoriteServices.isCreatorFavorited(creatorID: creator.id)
            }
        }
    }
}

struct DetailContentView: View {
    let content: DetailContent
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    AsyncImage(url: URL(string: content.imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                            .shadow(radius: 2)
                    } placeholder: {
                        ProgressView()
                    }
                    VStack(alignment: .leading) {
                        Text(content.name)
                            .font(.title)
                            .padding(.bottom, 5)
                        if let rating = content.rating {
                            StarRatingView(rating: rating)
                        }
                        if let releasedDate = content.releasedDate {
                            Text("Released: \(releasedDate)")
                                .font(.subheadline)
                        }
                        if let metacritic = content.metacritic {
                            Text("Metacritic Score \(metacritic)")
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground).opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .shadow(radius: 5)
                if let description = content.description, !description.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Description")
                            .font(.title2)
                        Text(description.htmlToString())
                            .lineLimit(8)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.top)
                }
                if let screenshots = content.screenshot, !screenshots.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Screenshot")
                            .font(.title2)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(screenshots, id: \.id) { screenshot in
                                    if let imageURL = URL(string: screenshot.image) {
                                        AsyncImage(url: imageURL) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 150)
                                                .cornerRadius(12)
                                                .shadow(radius: 5)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.white, lineWidth: 2)
                                                )
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .padding(.top)
                }
                if let achievements = content.achievement, !achievements.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Achievement")
                            .font(.title3)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(achievements, id: \.id) { achievement in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            if let imageURL = URL(string: achievement.image) {
                                                AsyncImage(url: imageURL) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(12)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(Color.gray, lineWidth: 1)
                                                        )
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                            }
                                            VStack(alignment: .leading) {
                                                Text(achievement.name)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                Text(achievement.description)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(nil)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: 200)
                                                Text("\(achievement.percent)%")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            .frame(maxWidth: 200)
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(.systemBackground))
                                                .shadow(radius: 5)
                                        )
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .padding(.top)
                }
                if let gamesCount = content.gamesCount {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Total Games")
                            .font(.title2)
                        Text("Total games developed : \(gamesCount)")
                            .lineLimit(8)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.top)
                }
                if let games = content.games, !games.isEmpty {
                    Section("Games") {
                        LazyVStack(spacing: 10) {
                            ForEach(games) { game in
                                Text(game.name)
                                    .font(.headline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(.systemBackground))
                                            .shadow(radius: 2)
                                    )
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .padding()
        }
    }
}

// Preview
#Preview {
    DetailView(id: 3498, filter: .games)
        .environment(\.managedObjectContext, CoreDataProvider.shared.persistenceContainer.viewContext)
}
