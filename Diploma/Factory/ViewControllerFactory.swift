//
//  ViewControllerFactory.swift
//  Industrial
//
//  Created by DmitriiG on 25.08.2022.
//

import Foundation
import UIKit

final class ViewControllerFactory {
    
    func createFeedViewController() -> FeedViewController {
        let coordinator = FeedCoordinator()
        let feedViewModel = FeedViewModel()
        let feedViewController = FeedViewController()
        feedViewController.coordinator = coordinator
        feedViewController.feedViewModel = feedViewModel
        return feedViewController
    }
    
}
