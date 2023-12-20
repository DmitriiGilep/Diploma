//
//  User.swift
//  Diploma
//
//  Created by DmitriiG on 06.09.2023.
//

import Foundation
import UIKit

final class DUser {
    var mail: String
    var name: String
    var avatar: URL?
    var status: String?
    
    init(mail: String, name: String, avatar: URL?, status: String?) {
        self.mail = mail
        self.name = name
        self.avatar = avatar
        self.status = status
    }
}
