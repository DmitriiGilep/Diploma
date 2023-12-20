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
    func loginViewController(coordinator: ProfileCoordinatorProtocol)
    func signUpViewController(coordinator: ProfileCoordinatorProtocol)
    func profileViewController(coordinator: ProfileCoordinatorProtocol, navControllerFromFactory: UINavigationController?)
    func photosViewController(profileViewController: ProfileViewController)
}

final class ProfileCoordinator: ProfileCoordinatorProtocol {
    
    var navController: UINavigationController?
    
    
    func loginViewController(coordinator: ProfileCoordinatorProtocol) {
        let loginViewController = LogInViewController(coordinator: coordinator)
        let myLoginFactory = MyLoginFactory()
        loginViewController.delegate = myLoginFactory.loginInspector()
        navController?.setViewControllers([loginViewController], animated: true)
    }
    
    func signUpViewController(coordinator: ProfileCoordinatorProtocol) {
        let signUpViewController = SignUpViewController(coordinator: coordinator)
        let myLoginFactory = MyLoginFactory()
        signUpViewController.delegate = myLoginFactory.loginInspector()
        navController?.setViewControllers([signUpViewController], animated: true)
    }
    
    func profileViewController(coordinator: ProfileCoordinatorProtocol, navControllerFromFactory: UINavigationController?) {
        let profileViewController = ProfileViewController(coordinator: coordinator)
        navController?.setViewControllers([profileViewController], animated: true)

    }
    
    func photosViewController(profileViewController: ProfileViewController) {
        let photosViewController = PhotosViewController()
        photosViewController.navigationController?.isNavigationBarHidden = false
        profileViewController.navigationController?.pushViewController(photosViewController, animated: true)
    }
    
}
