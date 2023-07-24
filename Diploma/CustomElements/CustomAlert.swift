//
//  CustomAlert.swift
//  Industrial
//
//  Created by DmitriiG on 05.12.2022.
//

import Foundation
import UIKit

final class CustomAlert {
    
    static let shared = CustomAlert()
    
    func createAlertWithCompletion(title: String?, message: String?, placeholder: String?, titleAction: String?, action: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if placeholder != nil {
            alertController.addTextField { text in
                text.placeholder = placeholder
            }
        }
        
        let alertAction = UIAlertAction(title: titleAction, style: .default) { UIAlertAction in
            action()
        }
        alertController.addAction(alertAction)
        return alertController
    }
    
    func createAlertWithCompletionTwoField(controller: UITextFieldDelegate, title: String?, message: String?, placeholder1: String?, placeholder2: String?,titleAction: String?, action: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if placeholder1 != nil {
            alertController.addTextField { text in
                text.placeholder = placeholder1
                text.delegate = controller
            }
        }
        
        if placeholder2 != nil {
            alertController.addTextField { text in
                text.placeholder = placeholder2
                text.delegate = controller
            }
        }
        
        let alertAction = UIAlertAction(title: titleAction, style: .default) { UIAlertAction in
            action()
        }
        alertController.addAction(alertAction)
        return alertController
    }
    
    func createAlertNoCompletion(title: String?, message: String?, titleAction: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: titleAction, style: .default)
        alertController.addAction(alertAction)
        return alertController
    }
    
    func createAlertWithTwoCompletion(title: String?, message: String?, placeholder: String?, titleAction1: String?, action1: @escaping () -> Void, titleAction2: String?, action2: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { text in
            text.placeholder = placeholder
        }
        
        let alertAction1 = UIAlertAction(title: titleAction1, style: .default) { UIAlertAction in
            action1()
        }
        alertController.addAction(alertAction1)
        let alertAction2 = UIAlertAction(title: titleAction2, style: .default) { UIAlertAction in
            action2()
        }
        alertController.addAction(alertAction2)
        return alertController
    }
    
    func createAlertWithThreeCompletion(title: String?, message: String?, placeholder1: String?, placeholder2: String?, titleAction1: String?, action1: @escaping () -> Void, titleAction2: String?, action2: @escaping () -> Void, titleAction3: String?, action3: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { text in
            text.placeholder = placeholder1
        }
        alertController.addTextField { text in
            text.placeholder = placeholder2
        }
        let alertAction1 = UIAlertAction(title: titleAction1, style: .default) { UIAlertAction in
            action1()
        }
        alertController.addAction(alertAction1)
        let alertAction2 = UIAlertAction(title: titleAction2, style: .default) { UIAlertAction in
            action2()
        }
        alertController.addAction(alertAction2)
        let alertAction3 = UIAlertAction(title: titleAction3, style: .default) { UIAlertAction in
            action3()
        }
        alertController.addAction(alertAction3)
        return alertController
    }
    
}
