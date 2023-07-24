//
//  CheckerService.swift
//  Industrial
//
//  Created by DmitriiG on 19.10.2022.
//

import Foundation
import UIKit
//import FirebaseAuth

protocol CheckerServiceControllerProtocol: AnyObject {
    func callAlertViewSignUpFailure()
    func callAlertViewSignUpSuccess()
    func callAlertViewCredentialFailure()
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
    
    func signUp(login: String, password: String) {
        
        guard !login.isEmpty, !password.isEmpty else {
            controller?.callAlertViewSignUpFailure()
            return
        }
        
        if realmModel?.checkLoginForUnique(login: login) == true {
            controller?.callAlertViewSignUpSuccess()
            realmModel?.addProfileToRealm(login: login, password: password)
            realmModel?.toogleStatusToLogIn(login: login)
            
        } else {
            controller?.callAlertViewSignUpFailure()
        }
    }
    
    func checkCredentials(login: String, password: String) {
        
        guard !login.isEmpty, !password.isEmpty else {
            controller?.callAlertViewCredentialFailure()
            return
        }
        
        if realmModel?.checkAuthorizationWithRealm(login: login, password: password) == true {
            realmModel?.toogleStatusToLogIn(login: login)
            controller?.goToProfilePage()
        } else {
            controller?.callAlertViewCredentialFailure()
        }
    }
    
}
        // firebase
  /*      Auth.auth().createUser(withEmail: login, password: password) { [weak self] authResult, error in
            if error == nil {
                let alertView = self!.createAlertView(viewTitle: "Успешная регистрация", message: "Пользователь успешно зарегистрирован", actionTitle: "ok")
                controller.present(alertView, animated: true, completion: nil)
            } else {

                let alertView = self!.createAlertView(viewTitle: "Ошибка регистрации", message: error!.localizedDescription, actionTitle: "ok")
                controller.present(alertView, animated: true, completion: nil)
            }
        }
      */
        
//        Auth.auth().signIn(withEmail: login, password: password) { [weak self] authResult, error in
//            let profileErrorsProcessor = ProfileErrorsProcessor()
//            if error != nil {
//                do {
//                    if  login.isEmpty && password.isEmpty {
//                        throw ProfileErrors.noLogInNoPassword
//                    } else if login.isEmpty {
//                        throw ProfileErrors.noLogIn
//                    } else if password.isEmpty {
//                        throw ProfileErrors.noPassword
//                    } else {
//                        throw ProfileErrors.wrongPassword
//                    }
//
//                } catch {
//                    if let catchedError = error as? ProfileErrors {
//                        let alertView = profileErrorsProcessor.processErrors(error: catchedError)
//                        controller.present(alertView, animated: true, completion: nil)
//                    }
//                }
//            } else {
//                coordinator.profileViewController(coordinator: coordinator)
//            }
//
//        }
