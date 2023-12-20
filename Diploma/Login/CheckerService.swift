//
//  CheckerService.swift
//  Industrial
//
//  Created by DmitriiG on 19.10.2022.
//

import Foundation
import UIKit
import FirebaseAuth

protocol CheckerServiceControllerProtocol: AnyObject {
    func callAlertViewCredentialFailure(error: String)
    func goToProfilePage()
    
}

protocol CheckerServiceRealmModelProtocol: AnyObject {
    func checkLoginForUnique(login: String) -> Bool
    func addProfileToRealm(login: String, password: String)
    func checkAuthorizationWithRealm(login: String, password: String) -> Bool
    func toogleStatusToLogIn(login: String)
}

final class CheckerService: CheckerServiceProtocol {
    
    var controller: CheckerServiceControllerProtocol?
    var realmModel: CheckerServiceRealmModelProtocol?
    
//    func signUp(login: String, password: String) {
//
//        guard !login.isEmpty, !password.isEmpty else {
//            controller?.callAlertViewSignUpFailure()
//            return
//        }
//
//        if realmModel?.checkLoginForUnique(login: login) == true {
//            controller?.callAlertViewSignUpSuccess()
//            realmModel?.addProfileToRealm(login: login, password: password)
//            realmModel?.toogleStatusToLogIn(login: login)
//
//        } else {
//            controller?.callAlertViewSignUpFailure()
//        }
//    }
    
//    func checkCredentials(login: String, password: String) {
//
//        guard !login.isEmpty, !password.isEmpty else {
//            controller?.callAlertViewCredentialFailure()
//            return
//        }
//
//        if realmModel?.checkAuthorizationWithRealm(login: login, password: password) == true {
//            realmModel?.toogleStatusToLogIn(login: login)
//            controller?.goToProfilePage()
//        } else {
//            controller?.callAlertViewCredentialFailure()
//        }
//    }
    
    
    // firebase
    func signUp(login: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        FirebaseAuth.Auth.auth().createUser(withEmail: login, password: password) { authResult, error in
            if error == nil {
                completion(true, nil)
            } else {
                completion(false, error!.localizedDescription)
            }
        }
    }
    
    func checkCredentials(login: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: login, password: password) { authResult, error in
            if error == nil {
                completion(true, nil)
            } else {
                completion(false, error?.localizedDescription)
            }
        }
    }
}


//        do {
//            try Auth.auth().signOut() // разлогинивает пользователя
//        } catch {
//            return
//        }
        
