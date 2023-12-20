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
    var postsFeed: [PostFeed] = []
    var postsProfile: [PostProfile] = []
    var user: [DCurUser] = []
    var IDMethodToLoad: [IDMethod] = []
    var status: [DCurStatus] = []

    lazy var isIDToUse: Bool = {
        let value: Bool
        if IDMethodToLoad.isEmpty {
            value = false
        } else {
            value = IDMethodToLoad[0].isIDToUse
        }
        return value
    }()
    
    private init() {
        loadPosts()
        loadPostsFeed()
        loadPostsProfile()
        loadDCurUser()
        loadIDMethod()
        loadStatus()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Diploma")
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

    func loadPostsFeed() {
        let request = PostFeed.fetchRequest()
        let posts = (try? contextBackground.fetch(request)) ?? []
        self.postsFeed = posts
    }
    
    func loadPostsProfile() {
        let request = PostProfile.fetchRequest()
        let posts = (try? contextBackground.fetch(request)) ?? []
        self.postsProfile = posts
    }

    func loadDCurUser() {
        let request = DCurUser.fetchRequest()
        let user = (try? contextBackground.fetch(request)) ?? []
        self.user = user
    }
    
    func loadIDMethod() {
        let request = IDMethod.fetchRequest()
        let IDMethod = (try? contextBackground.fetch(request)) ?? []
        self.IDMethodToLoad = IDMethod
    }
    
    func loadStatus() {
        let request = DCurStatus.fetchRequest()
        let status = (try? contextBackground.fetch(request)) ?? []
        self.status = status
    }
    
    private func newBatchInsertRequestProfile(with posts: [PostProtocol])
      -> NSBatchInsertRequest {
      var index = 0
      let total = posts.count
          
      let batchInsert = NSBatchInsertRequest(
        entity: PostProfile.entity()) { (managedObject: NSManagedObject) -> Bool in

            guard index < total else { return true }

        if let post = managedObject as? PostProfile {
          let data = posts[index]
            post.id = data.id
            post.author = data.author
            post.avatarImage = data.avatarImage
            post.descriptionOfPost = data.descriptionOfPost
            post.image = data.image
            post.views = data.views
            post.likes = data.likes
        }

        index += 1
        return false
      }
      return batchInsert
    }
    
    private func newBatchInsertRequestFav(with posts: [PostProtocol])
      -> NSBatchInsertRequest {
      var index = 0
      let total = posts.count
          
      let batchInsert = NSBatchInsertRequest(
        entity: PostFav.entity()) { (managedObject: NSManagedObject) -> Bool in

            guard index < total else { return true }

        if let post = managedObject as? PostFav {
          let data = posts[index]
            post.id = data.id
            post.author = data.author
            post.avatarImage = data.avatarImage
            post.descriptionOfPost = data.descriptionOfPost
            post.image = data.image
            post.views = data.views
            post.likes = data.likes
        }

        index += 1
        return false
      }
      return batchInsert
    }
    
    func addAllpostProf(postProf: [PostProtocol]) {

        if !postProf.isEmpty {
            let insertRequestProf = newBatchInsertRequestProfile(with: postProf)
            insertRequestProf.resultType = NSBatchInsertRequestResultType.objectIDs
            guard let resultProf = try? contextBackground.execute(insertRequestProf) as? NSBatchInsertResult else {
                return
            }
            if let objectIDsProf = resultProf.result as? [NSManagedObjectID], !objectIDsProf.isEmpty {
                let save = [NSInsertedObjectsKey: objectIDsProf]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: save, into: [contextBackground])
                self.saveBackgroundContext()
                self.loadPostsProfile()
            }
        }
    }
    
    func addAllpostFav(postFav: [PostProtocol]) {
        
        if !postFav.isEmpty {
            let insertRequestFav = newBatchInsertRequestFav(with: postFav)
            insertRequestFav.resultType = NSBatchInsertRequestResultType.objectIDs
            guard let resultFav = try? contextBackground.execute(insertRequestFav) as? NSBatchInsertResult else {
                return
            }
            if let objectIDsFav = resultFav.result as? [NSManagedObjectID], !objectIDsFav.isEmpty {
                let save = [NSInsertedObjectsKey: objectIDsFav]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: save, into: [contextBackground])
                self.saveBackgroundContext()
                self.loadPosts()
            }
        }
        
    }
    
    func addPost(post: PostProtocol) {
        contextBackground.perform {
            let postFav = PostFav(context: self.contextBackground)
            postFav.author = post.author
            postFav.avatarImage = post.avatarImage
            postFav.descriptionOfPost = post.descriptionOfPost
            postFav.image = post.image
            postFav.likes = post.likes
            postFav.views = post.views
            FirebaseSingleton.shared.storeData(type: .favorites, status: nil, favoritePost: post, profilePost: nil)
            self.saveBackgroundContext()
            self.loadPosts()
        }
    }
    
    func addPostFeed(post: PostProtocol) {
        contextBackground.perform {
            let postFeed = PostFeed(context: self.contextBackground)
//            let avatarImageData = post.avatarImage?.jpegData(compressionQuality: 1.0)
//            let imageData = post.image?.jpegData(compressionQuality: 1.0)
            postFeed.author = post.author
            postFeed.avatarImage = post.avatarImage
            postFeed.descriptionOfPost = post.descriptionOfPost
            postFeed.image = post.image
            postFeed.likes = post.likes
            postFeed.views = post.views
            self.saveBackgroundContext()
            self.loadPostsFeed()
        }
    }
    
    func addPostProfile(post: PostProtocol) {
        contextBackground.perform { [self] in
            let postFeed = PostProfile(context: self.contextBackground)
            postFeed.author = post.author
            postFeed.avatarImage = post.avatarImage
            postFeed.descriptionOfPost = post.descriptionOfPost
            postFeed.image = post.image
            postFeed.likes = post.likes
            postFeed.views = post.views
            FirebaseSingleton.shared.storeData(type: .profile, status: nil, favoritePost: nil, profilePost: post)
            self.saveBackgroundContext()
            self.loadPostsProfile()
        }
    }
    
    func saveCurrentUser(user: DUser) {
        contextBackground.perform { [self] in
            let currentUserToSave = DCurUser(context: self.contextBackground)
            let userAvatar: String
            let userStatus: String
            if let userAvatarFromUser = user.avatar?.absoluteString {
                userAvatar = userAvatarFromUser
            } else {
                userAvatar = ""
            }
            if let userStatusFromUser = user.status {
                userStatus = userStatusFromUser
            } else {
                userStatus = ""
            }

            currentUserToSave.mail = user.mail
            currentUserToSave.name = user.name
            currentUserToSave.avatarImage = userAvatar
            currentUserToSave.status = userStatus

            self.saveBackgroundContext()
            self.loadDCurUser()
        }
    }
    
    func deletePost(post: PostFav) {
        persistentContainer.viewContext.delete(post)
        if let id = post.id {
            FirebaseSingleton.shared.deletePost(type: .favorites, id: id)
        }
        saveContext()
//            self.contextBackground.delete(post)
//            self.saveBackgroundContext()
        
    }
    
    func deletePost(post: PostFeed) {
        contextBackground.delete(post)
        saveBackgroundContext()
//        persistentContainer.viewContext.delete(post)
//        saveContext()
//            self.contextBackground.delete(post)
//            self.saveBackgroundContext()
        loadPostsFeed()
    }
    
    func deletePost(post: PostProfile) {
        contextBackground.delete(post)
        if let id = post.id {
            FirebaseSingleton.shared.deletePost(type: .profile, id: id)
        }
        saveBackgroundContext()
        loadPostsProfile()
    }
    
    func deleteDCurUser(user: DCurUser) {
        contextBackground.delete(user)
        saveBackgroundContext()
        loadDCurUser()
    }
    
    func deleteID(id: IDMethod) {
        contextBackground.delete(id)
        saveBackgroundContext()
        loadIDMethod()
    }
    
    func updateUser(user: DCurUser) {
        contextBackground.perform { [self] in
            guard let currentUserToUpdate = contextBackground.object(with: user.objectID) as? DCurUser else {return}
            currentUserToUpdate.status = user.status
            FirebaseSingleton.shared.storeData(type: .status, status: user.status, favoritePost: nil, profilePost: nil)
            self.saveBackgroundContext()
            self.loadDCurUser()
        }
    }
    
    func emptyUserList() {
        contextBackground.perform {
            self.user.forEach { user in
                self.deleteDCurUser(user: user)
            }
        }
    }
    
    func changeAuthMethod() {
        contextBackground.perform { [self] in
            if self.IDMethodToLoad.isEmpty {
                let IDMethodToAdd = IDMethod(context: self.contextBackground)
                IDMethodToAdd.isIDToUse = true
                saveBackgroundContext()
                loadIDMethod()
                
            } else {
                guard let currentIsIDToUse = contextBackground.object(with: self.IDMethodToLoad[0].objectID) as? IDMethod else {return}
                currentIsIDToUse.isIDToUse = !currentIsIDToUse.isIDToUse
                saveBackgroundContext()
                loadIDMethod()
            }
        }
    }
    
    func emptyIDMethod(completion: (() -> Void)?) {
        contextBackground.perform { [self] in
            self.IDMethodToLoad.forEach { id in
                self.deleteID(id: id)
            }
            if let completion = completion {
                    completion()
            }
        }
    }
    
    func changeStatusToTrue() {
        contextBackground.perform { [self] in
            if self.status.isEmpty {
                let status = DCurStatus(context: self.contextBackground)
                status.status = true
                saveBackgroundContext()
                loadStatus()
                
            } else {
                guard let status = contextBackground.object(with: self.status[0].objectID) as? DCurStatus else {return}
                status.status = true
                saveBackgroundContext()
                loadStatus()
            }
        }
    }
    
    func changeStatusToFalse() {
        contextBackground.perform { [self] in
            if !self.status.isEmpty {
                guard let status = contextBackground.object(with: self.status[0].objectID) as? DCurStatus else {return}
                status.status = false
                saveBackgroundContext()
                loadStatus()
            }
        }
    }
    
    func deleteAll(type: DataTypeForRetrive) {
        
            let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        
        switch type {
        case .favorites:
            fetchRequest = NSFetchRequest(entityName: "PostFav")

        case .profile:
            fetchRequest = NSFetchRequest(entityName: "PostProfile")

        }
        
            
            let deleteRequest = NSBatchDeleteRequest(
                fetchRequest: fetchRequest
            )
            
//             deleteRequest.resultType = .resultTypeObjectIDs
            
        guard (try? contextBackground.execute(deleteRequest) as? NSBatchDeleteResult) != nil else {return}
    }
    
}
