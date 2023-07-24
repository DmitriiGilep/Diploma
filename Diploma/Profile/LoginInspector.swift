//
//  LoginInspector.swift
//  Industrial
//
//  Created by DmitriiG on 13.08.2022.
//

import UIKit

//MARK: - новый класс, подписанный на протокол LoginViewControllerDelegate

final class LoginInspector: LoginViewControllerDelegate {
    
//    lazy var checkerService = CheckerService(controller: checkerServiceController) // переменная должна быть вне completion, то есть нужно держать ссылку на CheckerService, если создаешь внутри, то ссылка не держится, когда асинхронно вызывается комплишн, этого сервиса уже нет, его никто не держит.

    func checkCredentials(login: String, password: String, controller: LogInViewController) {
        let checkerService = CheckerService()
        checkerService.controller = controller
        checkerService.realmModel = LoginRealmModel.shared
        checkerService.checkCredentials(login: login, password: password)
    }
    
    func signUp(login: String, password: String, controller: LogInViewController) {
        let checkerService = CheckerService()
        checkerService.controller = controller
        checkerService.realmModel = LoginRealmModel.shared
        checkerService.signUp(login: login, password: password)
    }
    
}
