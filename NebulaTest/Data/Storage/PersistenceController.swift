import CoreData

struct PersistenceController {
    private static let modelName = "NebulaTest"

    // Loading the model once keeps entity-to-class mapping unique when several
    // containers exist in one process, for example in unit tests.
    private static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load Core Data model \(modelName)")
        }
        return model
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: Self.modelName, managedObjectModel: Self.model)
        if inMemory, let description = container.persistentStoreDescriptions.first {
            description.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
