//
//  FeedCoordinatorTests.swift
//  FeedCoordinatorTests
//
//  Created by DmitriiG on 15.03.2023.
//

import Foundation
import XCTest
@testable import Industrial

final class FeedCoordinatorTests: XCTestCase {

    private var coordinator: StubFeedCoordinator!
    private var feedViewModel: FeedViewModel!
    private var feedViewController: FeedViewController!
    let infoViewModel = InfoViewModel()
    lazy var infoViewController = InfoViewController(coordinator: coordinator, model: infoViewModel)
    
    override func setUpWithError() throws {
        coordinator = StubFeedCoordinator()
        feedViewModel = FeedViewModel()
        feedViewController = FeedViewController()
        feedViewController.coordinator = coordinator
        feedViewController.feedViewModel = feedViewModel
        let navigationController = UINavigationController(rootViewController: UIViewController())
        coordinator.navController = navigationController
        navigationController.pushViewController(feedViewController, animated: false)
        
    }

    override func tearDownWithError() throws {
        coordinator = nil
    }

    func testPostViewController() throws {
        feedViewController.coordinator?.postViewController()
        XCTAssert(coordinator.postViewControllerCalled)
    }
    
    func testMapViewController() throws {
        feedViewController.coordinator?.mapViewController()
        XCTAssert(coordinator.mapViewControllerCalled)
    }

    func testInfoViewController() throws {
        feedViewController.coordinator?.infoViewController(completion: nil)
        XCTAssert(coordinator.infoViewControllerCalled)
    }
    
    func testAlertViewController() throws {
        feedViewController.coordinator?.alertView(infoViewController: infoViewController)
        XCTAssert(coordinator.alertViewCalled)
    }

}

final class StubFeedCoordinator: FeedCoordinatorProtocol {
    
    var navController: UINavigationController?
    
    var postViewControllerCalled = false
    var mapViewControllerCalled = false
    var infoViewControllerCalled = false
    var alertViewCalled = false
    
    
    func postViewController() {
        postViewControllerCalled = true
    }
    
    func mapViewController() {
        mapViewControllerCalled = true
    }
    
    func infoViewController(completion: ((Industrial.InfoViewController) -> ())?) {
        infoViewControllerCalled = true
    }
    
    func alertView(infoViewController: Industrial.InfoViewController) {
        alertViewCalled = true
    }
    
    
}

