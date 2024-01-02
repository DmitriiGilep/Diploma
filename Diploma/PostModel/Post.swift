//
//  Post.swift
//  Navigation
//
//  Created by DmitriiG on 15.05.2022.
//

import Foundation
import UIKit

public protocol PostProtocol {
    var id: String { get set }
    var author: String { get set }
    var avatarImage: String? { get set }
    var descriptionOfPost: String { get set }
    var image: String? { get set }
    var likes: Int16 { get set }
    var views: Int16 { get set }
}

public struct Post: PostProtocol {
    public var id = UUID().uuidString
    public var author: String
    public var avatarImage: String?
    public var descriptionOfPost: String
    public var image: String?
    public var likes: Int16
    public var views: Int16
}

public struct PostToPresent {
    public var id = UUID().uuidString
    public var author: String
    public var avatarImage: UIImage?
    public var descriptionOfPost: String
    public var image: UIImage?
    public var likes: Int16
    public var views: Int16
}

public class PostData {

    public var postDataArray = [PostProtocol]()
    
    public func createPost(data: Post) {
        postDataArray.append(data)
    }
    
}
