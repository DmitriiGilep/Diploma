//
//  FeedModel.swift
//  Industrial
//
//  Created by DmitriiG on 19.08.2022.
//

import Foundation

//MARK: - Dependancies via initialisation

//#if RELEASE

final class FeedModel {
    
    let passwordForCheck: String
    
    private let secretWord = "secretWord".localizable
    
    init(passwordForCheck: String) {
        self.passwordForCheck = passwordForCheck
    }
    
    func check()-> Bool {
        if passwordForCheck == secretWord {
            return true
        } else {
            return false
        }
    }
    
}

//#else

//MARK: - Protocol Observer

//protocol Checkable: AnyObject {
//    func receiveResult(result: Bool)
//}
//
//final class FeedModel {
//
//    private lazy var subscribers = [Checkable]()
//
//    private let secretWord = "пароль"
//    var passwordForCheck = ""
//
//    // добавляем подписчика
//    func subscribe(_ subscriber: Checkable) {
//        subscribers.append(subscriber)
//    }
//    // удаляем подписчика
//    func removeSubscriber(_ subscriber: Checkable) {
//        guard let index = subscribers.firstIndex(where: {
//            $0 === subscriber
//        }) else { return }
//        subscribers.remove(at: index)
//
//    }
//
//    // передает данные о пароле, и запускает notify
//    func transferAndCheckPassword(passwordForCheck: String) {
//        if check(password: passwordForCheck) { notify(resultOfCheck: true)
//        } else { notify(resultOfCheck: false)}
//    }
//
//    // уведомляет подписчиков
//    private func notify(resultOfCheck: Bool) {
//        subscribers.forEach {
//            $0.receiveResult(result: resultOfCheck)
//        }
//    }
//
//    private func check(password: String)-> Bool {
//        if password == secretWord {
//            return true
//        } else {
//            return false
//        }
//    }
//
//}
//#endif
