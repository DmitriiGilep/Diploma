//
//  MyLoginFactory.swift
//  Industrial
//
//  Created by DmitriiG on 14.08.2022.
//

import Foundation

class MyLoginFactory: LoginFactoryProtocol {
    
    func loginInspector() -> LoginInspector {
        return LoginInspector()
    }
    
    
    
}
