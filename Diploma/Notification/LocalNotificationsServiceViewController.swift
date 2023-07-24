//
//  LocalNotificationsServiceViewController.swift
//  Industrial
//
//  Created by DmitriiG on 11.04.2023.
//

import UIKit
import UserNotifications

final class LocalNotificationsServiceViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func registerUpdatesCategory() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let update = UNNotificationAction(identifier: "updateAction", title: "update".localizable, options: .foreground)
        let category = UNNotificationCategory(identifier: "updates", actions: [update], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    func registerForLatestUpdatesIfPossible() {
        UNUserNotificationCenter.current().requestAuthorization(options: [ .sound, .badge, .provisional ]) { [weak self] granted, error in
            if granted {
                self?.registerUpdatesCategory()
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
                
                let content = UNMutableNotificationContent()
                content.title = "alert_title".localizable
                content.body = "look_update".localizable
                content.interruptionLevel = .critical
                content.sound = .defaultCritical
                content.categoryIdentifier = "updates"
                
                var dateComponent = DateComponents()
                dateComponent.hour = 19
                dateComponent.minute = 00
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        //        let triggerTest = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request)
                
            } else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "updateAction":
            let profileCoordinator = ProfileCoordinator()
            let loginViewController = LogInViewController(coordinator: profileCoordinator)
            let myLoginFactory = MyLoginFactory()
            loginViewController.delegate = myLoginFactory.loginInspector()
            
//            guard let window = UIApplication.shared.keyWindow?.window else {return}
            guard let window = ((UIApplication.shared.connectedScenes.first as? UIWindowScene)!.delegate as! UIWindowSceneDelegate).window else {return}
            guard let tabBarController = window?.rootViewController as? UITabBarController else {return}
            guard let navController = tabBarController.selectedViewController as? UINavigationController else {return}
            profileCoordinator.navController = navController
            if LoginRealmModel.shared.status.status {
                profileCoordinator.profileViewController(coordinator: profileCoordinator, controller: loginViewController, navControllerFromFactory: nil)
            } else {
                navController.pushViewController(loginViewController, animated: true)
            }
            
        default:
            break
        }
        completionHandler()
    }

}
