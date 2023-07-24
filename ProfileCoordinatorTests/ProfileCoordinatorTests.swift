//
//  ProfileCoordinatorTests.swift
//  ProfileCoordinatorTests
//
//  Created by DmitriiG on 20.03.2023.
//

import XCTest
@testable import Industrial

final class ProfileCoordinatorTests: XCTestCase {

    private var coordinator: StubProfileCoordinator!
    private var loginViewController: LogInViewController!
    
    
    override func setUpWithError() throws {
        coordinator = StubProfileCoordinator()
        loginViewController = LogInViewController(coordinator: coordinator)
        let navigationController = UINavigationController(rootViewController: UIViewController())
        coordinator.navController = navigationController
        navigationController.pushViewController(loginViewController, animated: false)
    }

    override func tearDownWithError() throws {
        coordinator = nil
        loginViewController = nil
    }

    func testProfileViewController() throws {
        coordinator.profileViewController(coordinator: coordinator, controller: loginViewController, navControllerFromFactory: nil)
        XCTAssert(coordinator.profileViewControllerCalled)
    }

    func testPhotosViewController() throws {
        let userService = TestUserService()
        let profileViewController = ProfileViewController(userService: userService, userName: "test", coordinator: coordinator, controller: loginViewController)
        coordinator.photosViewController(profileViewController: profileViewController)
        XCTAssert(coordinator.photosViewControllerCalled)
    }
    
    func testFavoritesTableViewController() throws {
        coordinator.favoritesTableViewController()
        XCTAssert(coordinator.favoritesTableViewControllerCalled)
    }
}

final class StubProfileCoordinator: ProfileCoordinatorProtocol {
    var navController: UINavigationController?
    var profileViewControllerCalled = false
    var photosViewControllerCalled = false
    var favoritesTableViewControllerCalled = false
    
    func profileViewController(coordinator: Industrial.ProfileCoordinatorProtocol, controller: Industrial.LogInViewController, navControllerFromFactory: UINavigationController?) {
        profileViewControllerCalled = true
    }
    
    func photosViewController(profileViewController: Industrial.ProfileViewController) {
        photosViewControllerCalled = true
    }
    
    func favoritesTableViewController() {
        favoritesTableViewControllerCalled = true
    }
}
