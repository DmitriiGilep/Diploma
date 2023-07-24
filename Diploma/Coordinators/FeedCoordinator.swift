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
    
    func postViewController()
    func mapViewController()
    func infoViewController(completion: ((InfoViewController) -> ())?)
    func alertView(infoViewController: InfoViewController)
}

final class FeedCoordinator: FeedCoordinatorProtocol {

    var navController: UINavigationController?
    
    func postViewController() {
        let coordinator = FeedCoordinator()
        let model = PostViewModel()
        let postViewController = PostViewController(coordinator: coordinator, model: model)
        navController?.pushViewController(postViewController, animated: true)
  //      navController?.popViewController(animated: true) // takes from the stack
    }
    
    func mapViewController() {
        let mapViewController = MapViewController()
        navController?.pushViewController(mapViewController, animated: true)
    }
    
    func infoViewController(completion: ((InfoViewController) -> ())?) {
        let coordinator = FeedCoordinator()
        let model = InfoViewModel()
        let infoViewController = InfoViewController(coordinator: coordinator, model: model)
        completion?(infoViewController)
   //     postViewController.present(infoViewController, animated: true, completion: nil)
        
    }
    
    func alertView(infoViewController: InfoViewController) {
        let alertView = UIAlertController(title: "alert_title".localizable, message: "don't_press_message".localizable, preferredStyle: .alert)
        let accepted = UIAlertAction(title: "accepted".localizable, style: .default, handler: {(Accepted) in print("well_done".localizable)})
        let notAccepted = UIAlertAction(title: "did't_accepted".localizable, style: .cancel, handler: {(notAccepted) in print("well_done".localizable)})
        alertView.addAction(accepted)
        alertView.addAction(notAccepted)
        
        // модальный вывод
        infoViewController.present(alertView, animated: true, completion: nil)
    }
    
    
    
}
