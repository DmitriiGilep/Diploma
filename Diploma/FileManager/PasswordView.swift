//
//  PasswordView.swift
//  Industrial
//
//  Created by DmitriiG on 04.12.2022.
//

import Foundation
import UIKit

final class PasswordView {
    
    var login: String?
    var loginStatus = false
    let alert = CustomAlert()
    let blurEffect = UIBlurEffect(style: .dark)
    lazy var blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
    
    
    func launchCreatePasswordAlertWindow(controller: UIViewController) {
        blurVisualEffectView.frame = controller.view.bounds
        controller.view.addSubview(blurVisualEffectView)
        lazy var alertControllerCreatePassword = alert.createAlertWithThreeCompletion(title: "create_password".localizable, message: "length_ not_less_4_symbols".localizable, placeholder1: "insert_login".localizable, placeholder2: "insert_password".localizable , titleAction1: "Ok", action1: {
            [weak self] in
            guard let login = alertControllerCreatePassword.textFields?[0].text else {return}
            guard let password = alertControllerCreatePassword.textFields?[1].text else {return}
            
            if login.count == 0 || password.count < 4 {
                let alert = self?.alert.createAlertWithCompletion(title: "error".localizable, message: "login_doesn't_meet_rules".localizable, placeholder: nil, titleAction: "repeat".localizable) {
                    self?.launchCreatePasswordAlertWindow(controller: controller)
                }
                controller.present(alert!, animated: true)
            } else {
                self?.launchCreatePasswordAlertWindow2(login: login, password: password, controller: controller)
            }

        }, titleAction2: "already_have_password".localizable, action2: {
            [weak self] in
            self?.launchInsertPasswordAlertWindow(controller: controller)
        }, titleAction3: "cancel".localizable, action3: {
            ()
        })
        alertControllerCreatePassword.textFields?[1].isSecureTextEntry = true
        controller.present(alertControllerCreatePassword, animated: true)
    }
    
    func launchCreatePasswordAlertWindow2(login: String, password: String, controller: UIViewController) {
        
        lazy var alertControllerCreatePassword2 = alert.createAlertWithTwoCompletion(title: "repeat_password".localizable, message: "insert_password_again".localizable, placeholder: "insert_password".localizable, titleAction1: "Ok", action1: {
            [weak self] in
            guard let passwordRep = alertControllerCreatePassword2.textFields?[0].text else {return}
            if password != passwordRep {
                let alertRepeat = self?.alert.createAlertWithCompletion(title: "error".localizable, message: "passwords_don't_match".localizable, placeholder: nil, titleAction: "repeat".localizable) {
                    self?.launchCreatePasswordAlertWindow(controller: controller)
                }
                controller.present(alertRepeat!, animated: true)
            } else {
                self?.addPassword(login: login, password: password, controller: controller)
            }
            
        }, titleAction2: "cancel".localizable, action2: {
            ()
        })
        alertControllerCreatePassword2.textFields?[0].isSecureTextEntry = true
        controller.present(alertControllerCreatePassword2, animated: true)
    }
    
    func launchInsertPasswordAlertWindow(controller: UIViewController) {
        
        lazy var alertControllerInsertPassword = alert.createAlertWithThreeCompletion(title: "insert_password".localizable, message: "insert_password".localizable, placeholder1: "insert_login".localizable, placeholder2: "insert_password".localizable, titleAction1: "Ok", action1: { [weak self] in
            guard let login = alertControllerInsertPassword.textFields?[0].text else {return}
            guard let password = alertControllerInsertPassword.textFields?[1].text else {return}
            self?.getPassword(login: login, password: password, controller: controller)
        }, titleAction2: "create_password".localizable, action2: {
            [weak self] in
            self?.launchCreatePasswordAlertWindow(controller: controller)
        }, titleAction3: "cancel".localizable, action3: {
            ()
        })
        alertControllerInsertPassword.textFields?[1].isSecureTextEntry = true
        controller.present(alertControllerInsertPassword, animated: true)
    }
    
    func launchChangePasswordAlertWindow(controller: UIViewController) {
        
        lazy var alertControllerChangePassword = alert.createAlertWithTwoCompletion(title: "change_password".localizable, message: "insert_password".localizable, placeholder: "insert_password".localizable, titleAction1: "Ok", action1: { [weak self] in
            guard let password = alertControllerChangePassword.textFields?[0].text else {return}
            if password.count < 4 {
                let alert = self?.alert.createAlertWithCompletion(title: "error".localizable, message: "login_doesn't_meet_rules".localizable, placeholder: nil, titleAction: "repeat".localizable) {
                    self?.launchChangePasswordAlertWindow(controller: controller)
                }
                controller.present(alert!, animated: true)
            } else {
                self?.launchChangePasswordAlertWindow2(password: password, controller: controller)
            }
            
            
        }, titleAction2: "cancel".localizable) {
            ()
        }
        alertControllerChangePassword.textFields?[0].isSecureTextEntry = true
        controller.present(alertControllerChangePassword, animated: true)
    }
    
    
    func launchChangePasswordAlertWindow2(password: String, controller: UIViewController) {
 
        lazy var alertControllerCreatePassword2 = alert.createAlertWithTwoCompletion(title: "repeat_password".localizable, message: "insert_password_again".localizable, placeholder: "insert_password".localizable, titleAction1: "Ok", action1: {
            [weak self] in
            guard let passwordRep = alertControllerCreatePassword2.textFields?[0].text else {return}
            if password != passwordRep {
                let alertRepeat = self?.alert.createAlertWithCompletion(title: "error".localizable, message: "passwords_don't_match".localizable, placeholder: nil, titleAction: "repeat".localizable) {
                    self?.launchChangePasswordAlertWindow(controller: controller)
                }
                controller.present(alertRepeat!, animated: true)
            } else {
                self?.updatePassword(newPassword: password, controller: controller)
            }
        }, titleAction2: "cancel".localizable, action2: {
            ()
        })
        alertControllerCreatePassword2.textFields?[0].isSecureTextEntry = true
        controller.present(alertControllerCreatePassword2, animated: true)
    }
    
    
    private func addPassword(login: String, password: String, controller: UIViewController) {
        guard let passData = password.data(using: .utf8) else {
            print("error_transforming_password".localizable)
            return
        }
        
        let attribute = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passData,
            kSecAttrAccount: login
        ] as CFDictionary
        
        let status = SecItemAdd(attribute, nil)
        
        if status == errSecSuccess {
            print("password_added".localizable)
            self.login = login
            blurVisualEffectView.removeFromSuperview()
            controller.navigationController?.isNavigationBarHidden = false
            loginStatus = true

        } else {
            print("error_adding_password:".localizable + "\(status)")
            lazy var alert = alert.createAlertWithCompletion(title: "error".localizable, message: "error_pair_login/password".localizable, placeholder: nil, titleAction: "Ok") {
                [weak self] in
                self?.launchCreatePasswordAlertWindow(controller: controller)
            }
            controller.present(alert, animated: true)
        }
    }
    
    private func getPassword(login: String, password: String, controller: UIViewController) {
        
        let  query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login,
            kSecReturnData: true
        ] as CFDictionary
        
        var extractedData: AnyObject?
        
        let status = SecItemCopyMatching(query, &extractedData)
        
        if status != errSecSuccess {
            print("error_receiving_password:".localizable + "\(status)")
            lazy var alert = alert.createAlertWithCompletion(title: "error".localizable, message: "error_password_doesn't_exist".localizable, placeholder: nil, titleAction: "Ok") {
                [weak self] in
                self?.launchInsertPasswordAlertWindow(controller: controller)
            }
            controller.present(alert, animated: true)
            return
        }
        
        guard let passData = extractedData as? Data,
              let passwordExtracted = String(data: passData, encoding: .utf8) else {
            print("error_transforming_password".localizable)
            return
        }
        
        if passwordExtracted == password {
            print(passwordExtracted)
            blurVisualEffectView.removeFromSuperview()
            controller.navigationController?.isNavigationBarHidden = false
            loginStatus = true
            self.login = login
            
        } else {
            lazy var alert = alert.createAlertWithCompletion(title: "error".localizable, message: "password_incorrect".localizable, placeholder: nil, titleAction: "Ok") {
                [weak self] in
                self?.launchInsertPasswordAlertWindow(controller: controller)
            }
            controller.present(alert, animated: true)

        }
        
    }
 
    func updatePassword(newPassword: String, controller: UIViewController) {
        
        guard let passData = newPassword.data(using: .utf8) else {
            print("error_transforming_password".localizable)
            return
        }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: self.login,
            kSecReturnData: false
        ] as CFDictionary
        
        let attribute = [
            kSecValueData: passData
        ] as CFDictionary
        
        let status = SecItemUpdate(query, attribute)
        
        if status == errSecSuccess {
            print("password_updated".localizable)
            lazy var alert = alert.createAlertWithCompletion(title: "password_updated".localizable, message: nil, placeholder: nil, titleAction: "Ok") {
                ()
            }
            controller.present(alert, animated: true)
        } else {
            print("error_updating_password:".localizable + "\(status)")
            lazy var alert = alert.createAlertWithCompletion(title: "error".localizable, message: nil, placeholder: nil, titleAction: "Ok") {
                ()
            }
            controller.present(alert, animated: true)
        }
    }
    
    
}
