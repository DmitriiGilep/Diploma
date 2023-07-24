//
//  FavoritesCoreData.swift
//  Industrial
//
//  Created by DmitriiG on 08.01.2023.
//

import Foundation
import CoreData
import UIKit

final class FavoritesCoreData {
    
    static let shared = FavoritesCoreData()
    
    var posts: [PostFav] = []
    
    private init() {
        loadPosts()
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Industrial")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    
    lazy var contextBackground: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }()
    
//    lazy var contextMain: NSManagedObjectContext = {
//        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
//        return context
//    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    func saveMainContext() {
//            if self.contextMain.hasChanges {
//                do {
//                    try self.contextMain.save()
//                } catch {
//                    let nserror = error as NSError
//                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//                }
//            }
//    }
    
    func saveBackgroundContext() {
        if self.contextBackground.hasChanges {
                do {
                    try self.contextBackground.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
    }
    
    func loadPosts() {
        let request = PostFav.fetchRequest()
        let posts = (try? contextBackground.fetch(request)) ?? []
        self.posts = posts

    }

    func addPost(post: PostProtocol) {
        contextBackground.perform {
            let postFav = PostFav(context: self.contextBackground)
            let imageData = post.image?.jpegData(compressionQuality: 1.0)
            postFav.author = post.author
            postFav.descriptionOfPost = post.descriptionOfPost
            postFav.image = imageData
            postFav.likes = post.likes
            postFav.views = post.views
            self.saveBackgroundContext()
            self.loadPosts()
        }
    }
    
    func deletePost(post: PostFav) {
        persistentContainer.viewContext.delete(post)
        saveContext()
//            self.contextBackground.delete(post)
//            self.saveBackgroundContext()
            self.loadPosts()
        
    }
    
}
