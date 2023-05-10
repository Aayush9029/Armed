//
//  Persistence.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-16.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "ArmedModels")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

func addStoredImage(imageData: Data, connected: Bool) {
    let context = PersistenceController.shared.container.viewContext
    let newStoredImage = StoredImage(context: context)
    newStoredImage.id = UUID()
    newStoredImage.timestamp = Date().timeIntervalSince1970
    newStoredImage.image = imageData
    newStoredImage.connected = connected

    do {
        try context.save()
        print("Saved")
    } catch {
        print("Error saving new StoredImage: \(error.localizedDescription)")
    }
}

func deleteAllCloudPhotos() {
    let fetchRequest: NSFetchRequest<StoredImage> = StoredImage.fetchRequest()
    let context = PersistenceController.shared.container.viewContext
    do {
        let results = try context.fetch(fetchRequest)
        for result in results {
            print("deleting..\(result.timestamp)")
            context.delete(result)
        }

        do {
            try context.save()
        } catch {
            print("Error saving new StoredImage: \(error.localizedDescription)")
        }
    } catch {
        print("Error fetching StoredImages: \(error.localizedDescription)")
    }
}
