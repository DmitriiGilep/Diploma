//
//  LoginInspector.swift
//  Industrial
//
//  Created by DmitriiG on 13.08.2022.
//

import UIKit

//MARK: - новый класс, подписанный на протокол LoginViewControllerDelegate

final class LoginInspector: LoginViewControllerDelegate, SignUpViewControllerDelegate {
    
    func checkCredentials(login: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let checkerService = CheckerService()
        checkerService.checkCredentials(login: login, password: password) { result, error in
            completion(result, error)
        }
    }
    
    func signUp(login: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let checkerService = CheckerService()
        checkerService.signUp(login: login, password: password) { result, error in
            completion(result, error)

        }
    }
    
}
