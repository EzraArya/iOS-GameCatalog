import Foundation
import CoreData

class FavoriteServices {
    static var viewContext: NSManagedObjectContext {
        CoreDataProvider.shared.persistenceContainer.viewContext
    }
    static func save() throws {
        try viewContext.save()
    }
    static func saveFavoriteGame(_ game: Game) {
        let games = FavoriteGame(context: viewContext)
        games.id = Int64(game.id)
        games.name = game.name
        games.slug = game.slug
        games.gameDescription = game.description
        games.metacritic = Int64(game.metacritic ?? 0)
        games.ratings = game.ratingGame
        games.releasedDate = game.releasedDate
        games.gamePhoto = game.gamePhoto
        do {
            try save()
        } catch {
            print(error)
        }
    }
    static func saveFavoriteDeveloper(_ developer: Developer) {
        let developers = FavoriteDeveloper(context: viewContext)
        developers.id = Int64(developer.id)
        developers.name = developer.name
        developers.gameCount = Int64(developer.gameCount)
        developers.gamePhoto = developer.gamePhoto
        developers.developerDescription = developer.description
        developers.slug = developer.slug
        do {
            try save()
        } catch {
            print(error)
        }
    }
    static func saveFavoriteCreator(_ creator: Creator) {
        let creators = FavoriteCreator(context: viewContext)
        creators.id = Int64(creator.id)
        creators.name = creator.name
        creators.backgroundImage = creator.backgroundImage
        creators.image = creator.image
        creators.creatorDescription = creator.description
        creators.gameCount = Int64(creator.gameCount)
        creators.slug = creator.slug
        do {
            try save()
        } catch {
            print(error)
        }
    }
    static func isGameFavorited(gameID: Int) -> Bool {
        let request: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", gameID)
        do {
            let count = try viewContext.count(for: request)
            return count > 0
        } catch {
            print("Error checking if game is favorited: \(error)")
            return false
        }
    }
    static func isDeveloperFavorited(developerID: Int) -> Bool {
        let request: NSFetchRequest<FavoriteDeveloper> = FavoriteDeveloper.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", developerID)
        do {
            let count = try viewContext.count(for: request)
            return count > 0
        } catch {
            print("Error checking if developer is favorited: \(error)")
            return false
        }
    }
    static func isCreatorFavorited(creatorID: Int) -> Bool {
        let request: NSFetchRequest<FavoriteCreator> = FavoriteCreator.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", creatorID)
        do {
            let count = try viewContext.count(for: request)
            return count > 0
        } catch {
            print("Error checking if creator is favorited: \(error)")
            return false
        }
    }
    static func removeGameFromFavorites(gameID: Int) {
        let request: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", gameID)
        do {
            if let game = try viewContext.fetch(request).first {
                viewContext.delete(game)
                try save()
            }
        } catch {
            print("Error removing game from favorites: \(error)")
        }
    }
    static func removeDeveloperFromFavorites(developerID: Int) {
        let request: NSFetchRequest<FavoriteDeveloper> = FavoriteDeveloper.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", developerID)
        do {
            if let developer = try viewContext.fetch(request).first {
                viewContext.delete(developer)
                try save()
            }
        } catch {
            print("Error removing developer from favorites: \(error)")
        }
    }
    static func removeCreatorFromFavorites(creatorID: Int) {
        let request: NSFetchRequest<FavoriteCreator> = FavoriteCreator.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", creatorID)
        do {
            if let creator = try viewContext.fetch(request).first {
                viewContext.delete(creator)
                try save()
            }
        } catch {
            print("Error removing creator from favorites: \(error)")
        }
    }
}
