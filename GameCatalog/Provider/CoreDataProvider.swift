import Foundation
import CoreData

class CoreDataProvider {
    static let shared = CoreDataProvider()
    let persistenceContainer: NSPersistentContainer
    private init() {
        persistenceContainer = NSPersistentContainer(name: "FavoritesModel")
        persistenceContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Error initializing FavoritesModel \(error)")
            }
        }
    }
}
