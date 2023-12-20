//
//  FirebaseSigleton.swift
//  Diploma
//
//  Created by DmitriiG on 02.12.2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

enum DataTypeForRetrive {
    case favorites
    case profile
}

final class FirebaseSingleton {
    
    enum DataType {
        case status
        case favorites
        case profile
    }
    
    
    
    static let shared = FirebaseSingleton()
    
    private init () {
        
    }
    
    func storeData(type: DataType, status: String?, favoritePost: PostProtocol?, profilePost: PostProtocol?) {
        
        if let user =  Auth.auth().currentUser {
            let rootRef = Database.database().reference()
            
            switch type {
            case .status:
                guard let status = status else {return}
                let userRef = rootRef.child("users").child(user.uid)
                let statusToStore = ["status": status]
                userRef.setValue(statusToStore)
                
            case .favorites:
                guard let favoritePost = favoritePost else {return}
                let favPostsRefForPost = rootRef.child("users").child(user.uid).child("favposts").child(favoritePost.id)
                
                let post: NSDictionary = [
                    "author": favoritePost.author,
                    "avatarImage": favoritePost.avatarImage ?? "n/a",
                    "descriptionOfPost": favoritePost.descriptionOfPost,
                    "image": favoritePost.image ?? "n/a",
                    "likes": favoritePost.likes,
                    "views": favoritePost.views,
                ]
                
                favPostsRefForPost.setValue(post)
                
            case .profile:
                guard let profilePost = profilePost else {return}
                let profPostsRef = rootRef.child("users").child(user.uid).child("profposts").child(profilePost.id)
                
                let post: NSDictionary = [
                    "author": profilePost.author,
                    "avatarImage": profilePost.avatarImage ?? "n/a",
                    "descriptionOfPost": profilePost.descriptionOfPost,
                    "image": profilePost.image ?? "n/a",
                    "likes": profilePost.likes,
                    "views": profilePost.views,
                ]
                
                profPostsRef.setValue(post)
                
            }
            
        }
        
    }
    
    func retrieveStatus(completion: @escaping(String) -> Void) {
        if let user =  Auth.auth().currentUser {
            let rootRef = Database.database().reference()
            let userRef = rootRef.child("users").child(user.uid)
            
            userRef.observeSingleEvent(of: .value) { data in
                let value = data.value as? NSDictionary
                let statusToBeAssigned = value?["status"] as? String ?? "Failed to retrieve data"
                completion(statusToBeAssigned)
            }
            
        }
    }
    
    func retrievePost(completionProf: @escaping([PostProtocol]) -> Void, completionFav: @escaping([PostProtocol]) -> Void) {
        if let user =  Auth.auth().currentUser {
            
            let rootRef = Database.database().reference()
            
            let postsRefProfposts = rootRef.child("users").child(user.uid).child("profposts")
            let postsRefFavposts = rootRef.child("users").child(user.uid).child("favposts")
            
            var profPostsArray: [Post] = []
            var favPostsArray: [Post] = []
            
            postsRefProfposts.observeSingleEvent(of: .value) { data in
                guard let dictionaryOfPosts = data.value as? NSDictionary else {
                    return}
                for (key, value) in dictionaryOfPosts {
                    let id = key as? String ?? "id cannot be converted"
                    let post = value as? NSDictionary ?? ["fail": "post cannot be converted"]
                    let author = post["author"] as? String ?? ""
                    let avatarImage = post["avatarImage"] as? String ?? ""
                    let descriptionOfPost = post["descriptionOfPost"] as? String ?? ""
                    let image = post["image"] as? String ?? ""
                    let likes = post["likes"] as? Int16 ?? 0
                    let views = post["views"] as? Int16 ?? 0
                    
                    let postExtracted = Post(id: id, author: author, avatarImage: avatarImage, descriptionOfPost: descriptionOfPost, image: image, likes: likes, views: views)
                    profPostsArray.append(postExtracted)
                    }
                completionProf(profPostsArray)

            }
            
            postsRefFavposts.observeSingleEvent(of: .value) { data in
                guard let dictionaryOfPosts = data.value as? NSDictionary else {
                    return}
                for (key, value) in dictionaryOfPosts {
                    let id = key as? String ?? "id cannot be converted"
                    let post = value as? NSDictionary ?? ["fail": "post cannot be converted"]
                    let author = post["author"] as? String ?? ""
                    let avatarImage = post["avatarImage"] as? String ?? ""
                    let descriptionOfPost = post["descriptionOfPost"] as? String ?? ""
                    let image = post["image"] as? String ?? ""
                    let likes = post["likes"] as? Int16 ?? 0
                    let views = post["views"] as? Int16 ?? 0
                    
                    let postExtracted = Post(id: id, author: author, avatarImage: avatarImage, descriptionOfPost: descriptionOfPost, image: image, likes: likes, views: views)
                    favPostsArray.append(postExtracted)
                    }
                completionFav(favPostsArray)

            }            
        }
    }
    
    func retrievePostTest(completionFav: @escaping([PostProtocol]) -> Void) {
        if let user =  Auth.auth().currentUser {
            
            let rootRef = Database.database().reference()
            
            let postsRefFavposts = rootRef.child("users").child(user.uid).child("favposts")
            
            var favPostsArray: [Post] = []
            
            postsRefFavposts.observeSingleEvent(of: .value) { data in
                guard let dictionaryOfPosts = data.value as? NSDictionary else {
                    return}
                for (key, value) in dictionaryOfPosts {
                    let id = key as? String ?? "id cannot be converted"
                    let post = value as? NSDictionary ?? ["fail": "post cannot be converted"]
                    let author = post["author"] as? String ?? ""
                    let avatarImage = post["avatarImage"] as? String ?? ""
                    let descriptionOfPost = post["descriptionOfPost"] as? String ?? ""
                    let image = post["image"] as? String ?? ""
                    let likes = post["likes"] as? Int16 ?? 0
                    let views = post["views"] as? Int16 ?? 0
                    
                    let postExtracted = Post(id: id, author: author, avatarImage: avatarImage, descriptionOfPost: descriptionOfPost, image: image, likes: likes, views: views)
                    favPostsArray.append(postExtracted)
                    }
                completionFav(favPostsArray)
            }
        }
    }
    
    func deletePost(type: DataTypeForRetrive, id: String) {
        if let user =  Auth.auth().currentUser {
            let rootRef = Database.database().reference()
            
            let postsRef = {
                switch type {
                case .favorites:
                    return rootRef.child("users").child(user.uid).child("favposts").child(id)
                case .profile:
                    return rootRef.child("users").child(user.uid).child("profposts").child(id)
                }
            }()
            
            postsRef.removeValue()
            
        }
    }
    
}
