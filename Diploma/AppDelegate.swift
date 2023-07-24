//
//  AppDelegate.swift
//  Navigation
//
//  Created by DmitriiG on 12.02.2022.
//

import UIKit
//import FirebaseCore
//import FirebaseAuth


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow?
//    let localNotificationsServiceViewController = LocalNotificationsServiceViewController()

  //   объявил свойство конфигурации
  //  var appConfiguration: AppConfiguration?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    //     инициализировал кейсом ref1
    //        appConfiguration = AppConfiguration.ref1
        
        //        FirebaseApp.configure() // добавил конфигурирование Firebase
        
//                window = UIWindow()
//                window?.makeKeyAndVisible()
//
//             localNotificationsServiceViewController.registerForLatestUpdatesIfPossible()
//
//                let mainCoordinator = MainCoordinator()
//                window?.rootViewController = mainCoordinator.startApplication()
//
        //        print("This is my Bundle url: \(Bundle.main.bundleURL)") // my Bundle
        //        print("This is my Sandbox url: \(FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask))")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
//        do {
//            try Auth.auth().signOut() // разлогинивает пользователя
//        } catch {
//            return
//        }
        
        
    }
    

}

