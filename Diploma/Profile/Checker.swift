//
//  Checker.swift
//  Industrial
//
//  Created by DmitriiG on 13.08.2022.
//

import Foundation
//import FirebaseAuth

final class Checker {
    
    private init() {}
    
    static let shared = Checker()
    
    private let login = "Dmitrii"
    private let pswd = "111"
    
    func checker(loginInserted: String, passwordInserted: String) -> Bool {
        if loginInserted.hash == login.hash && passwordInserted.hash == pswd.hash {
            return true
        } else {
          return  false
        }
       
    }
    
}

