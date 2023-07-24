//
//  GenerateRandomPassword.swift
//  Industrial
//
//  Created by DmitriiG on 08.09.2022.
//

import Foundation

final class GenerateRandomPassword {
    
    
    private var digits:      String { return "0123456789" }
    private var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    private var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    private var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    private var letters:     String { return lowercase + uppercase }
    
    private var printable:   String { return digits + letters + punctuation }
    
    // private let rangeOfElements = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%&()0123456789"
    
    func randomPassword() -> String {
        let passLength = UInt.random(in: 3...4)
        var password = ""
        for _ in 0 ..< passLength {
            password.append(printable.randomElement()!)
        }
        return password
    }
    
    
}
