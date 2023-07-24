//
//  ProfileCoordinator.swift
//  Industrial
//
//  Created by DmitriiG on 25.08.2022.
//

import Foundation
import UIKit

protocol ProfileCoordinatorProtocol {
    var navController: UINavigationController? { get set }
    func profileViewController(coordinator: ProfileCoordinatorProtocol, controller: LogInViewController, navControllerFromFactory: UINavigationController?)
    func photosViewController(profileViewController: ProfileViewController)
    func favoritesTableViewController()

}

final class ProfileCoordinator: ProfileCoordinatorProtocol {
    
    var navController: UINavigationController?
    
    func profileViewController(coordinator: ProfileCoordinatorProtocol, controller: LogInViewController, navControllerFromFactory: UINavigationController?) {
 #if DEBUG
        let userService = TestUserService()
#else
        let userService = CurrentUserService()
#endif
        let profileViewController = ProfileViewController(userService: userService, userName: LoginRealmModel.shared.status.login ?? "undefined".localizable, coordinator: coordinator, controller: controller)
//        if let navFromFactory = navControllerFromFactory {
//            navFromFactory.pushViewController(profileViewController, animated: true)
//        } else {
            navController?.pushViewController(profileViewController, animated: true)
 //       }
        
    }
    
    func photosViewController(profileViewController: ProfileViewController) {
        let photosViewController = PhotosViewController()
        photosViewController.navigationController?.isNavigationBarHidden = false
        profileViewController.navigationController?.pushViewController(photosViewController, animated: true)
    }
    
    func favoritesTableViewController() {
        if #available(iOS 16.0, *) {
            let favoritesTableViewController = FavoritesTableViewController()
            navController?.navigationBar.isHidden = false
            navController?.pushViewController(favoritesTableViewController, animated: true)
        } else {
            let alert = CustomAlert.shared.createAlertNoCompletion(title: "Warning", message: "This link is unavailable for your version of OS", titleAction: "ok".localizable)
            navController?.present(alert, animated: true)
        }
    }
    
    
}
