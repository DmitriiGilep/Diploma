//
//  ProfileModel.swift
//  Industrial
//
//  Created by DmitriiG on 24.09.2022.
//

import Foundation
import UIKit

// enum с ошибками
enum ProfileErrors: Error {
    case noLogInNoPassword
    case noLogIn
    case noPassword
    case wrongPassword
    case unknownError
    case noImagesForCollection
}

final class ProfileErrorsProcessor {
    
    // функция обрабатывает ошибки
    func processErrors(error: ProfileErrors) -> UIAlertController{
        var alertView = UIAlertController()
        switch error {
        case .noLogInNoPassword:
            alertView = profileErrorAlert(message: "insert_login_password".localizable)
        case .noLogIn:
            alertView = profileErrorAlert(message: "insert_login".localizable)
        case .noPassword:
            alertView = profileErrorAlert(message: "insert_password".localizable)
        case .wrongPassword:
            alertView = profileErrorAlert(message: "password_login_incorrect".localizable)
        case.unknownError:
            alertView = profileErrorAlert(message: "unknown_error".localizable)
        case .noImagesForCollection:
            alertView = profileErrorAlert(message: "no_images_in_collection".localizable)
        }
        return alertView
    }
    
    // функция выводит alert при ошибках
    private func profileErrorAlert(message: String) -> UIAlertController {
        let alertView = UIAlertController(title: "error".localizable, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default)
        alertView.addAction(ok)
        return alertView
    }
}
