//
//  NavControllerFactory.swift
//  Industrial
//
//  Created by DmitriiG on 25.08.2022.
//

import Foundation
import UIKit
import PhotosUI

final class NavControllerFactory {
    
    enum NavControllerName {
        case first
        case second
        case third
    }
    
    var id: String?
    
    var navController = UINavigationController()
    private let navControllerName: NavControllerName
    
    @objc func goToViewController() {
        //navController.pushViewController(controller, animated: true)
        ()
    }
    
    init(navControllerName: NavControllerName) {
        self.navControllerName = navControllerName
        createNavController()
    }
    
    func createNavController() {
        switch navControllerName {
        case .first:
            let feedCoordinator = FeedCoordinator()
            let feedViewController = FeedViewController()
            feedViewController.coordinator = feedCoordinator
            feedCoordinator.navController = navController
            navController.setViewControllers([feedViewController], animated: true)
            
            let tabBar1 = UITabBarItem()
            tabBar1.title = "home".localizable
            tabBar1.image = UIImage(systemName: "house")
            navController.tabBarItem = tabBar1
            
            
        case .second:
            let profileCoordinator = ProfileCoordinator()
            profileCoordinator.navController = navController
            
           let myLoginFactory = MyLoginFactory()

            if FavoritesCoreData.shared.user.isEmpty == false {
                
                let loginViewController = LogInViewController(coordinator: profileCoordinator)
                loginViewController.delegate = myLoginFactory.loginInspector()
                navController.setViewControllers([loginViewController], animated: true)
                
            } else {
                
                let signUpViewController = SignUpViewController(coordinator: profileCoordinator)
                signUpViewController.delegate = myLoginFactory.loginInspector()
                navController.setViewControllers([signUpViewController], animated: true)
                
            }
            navController.navigationBar.isHidden = true
            
            let tabBar2 = UITabBarItem()
            tabBar2.title = "profile".localizable
            tabBar2.image = UIImage(systemName: "person.fill")
            navController.tabBarItem = tabBar2
            
        case .third:
            let favoritesTableViewController = FavoritesTableViewController()
            navController.navigationBar.isHidden = false
            navController.navigationBar.barStyle = .default
            navController.setViewControllers([favoritesTableViewController], animated: true)
            navController.tabBarItem = UITabBarItem(title: "favorites".localizable, image: UIImage(systemName: "star"), selectedImage: nil)
        }
    }
    
}
