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

final class CheckerService: CheckerServiceProtocol {
    
    var controller: CheckerServiceControllerProtocol?
    
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
        
