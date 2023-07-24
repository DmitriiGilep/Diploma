//
//  NavControllerFactory.swift
//  Industrial
//
//  Created by DmitriiG on 25.08.2022.
//

import Foundation
import UIKit
import PhotosUI
import RealmSwift

final class NavControllerFactory {
    
    enum NavControllerName {
        case first
        case second
        case third
    }
    
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
            let feedViewModel = FeedViewModel()
            let feedViewController = FeedViewController()
            feedViewController.coordinator = feedCoordinator
            feedViewController.feedViewModel = feedViewModel
            feedCoordinator.navController = navController
            navController.setViewControllers([feedViewController], animated: true)
            
            let tabBar1 = UITabBarItem()
            tabBar1.title = "home".localizable
            tabBar1.image = UIImage(systemName: "house")
            navController.tabBarItem = tabBar1
            
        case .second:
            
            let profileCoordinator = ProfileCoordinator()
            let loginViewController = LogInViewController(coordinator: profileCoordinator)
            let myLoginFactory = MyLoginFactory()
            loginViewController.delegate = myLoginFactory.loginInspector()
            profileCoordinator.navController = navController
            navController.setViewControllers([loginViewController], animated: true)
 
            if LoginRealmModel.shared.status.status {
                profileCoordinator.profileViewController(coordinator: profileCoordinator, controller: loginViewController, navControllerFromFactory: navController)
            }
            navController.navigationBar.isHidden = true
            
            let tabBar2 = UITabBarItem()
            tabBar2.title = "profile".localizable
            tabBar2.image = UIImage(systemName: "person.fill")
            navController.tabBarItem = tabBar2
            
        case .third:
            let fileManagerTableViewController = FileManagerTableViewController(style: .plain)
            navController.navigationBar.barStyle = .default
            navController.setViewControllers([fileManagerTableViewController], animated: true)
            navController.tabBarItem = UITabBarItem(title: "fileManager".localizable, image: UIImage(systemName: "photo"), selectedImage: nil)
        }
    }
    
}
