//
//  FeedCoordinator.swift
//  Industrial
//
//  Created by DmitriiG on 25.08.2022.
//

import Foundation
import UIKit

protocol FeedCoordinatorProtocol {
    var navController: UINavigationController? { get set }
    
}

final class FeedCoordinator: FeedCoordinatorProtocol {

    var navController: UINavigationController?
    
    func postViewController(controller: UIViewController) {
        let postViewController = PostViewController()
        let postNavController = UINavigationController(rootViewController: postViewController)
        controller.present(postNavController, animated: true, completion: nil)
    }
    
}
