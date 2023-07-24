//
//  TestUserService.swift
//  Industrial
//
//  Created by DmitriiG on 04.08.2022.
//

import Foundation
import UIKit

class TestUserService: UserService {
    
    var user = User(name: "Guest", avatar: UIImage(named: "GuestAvatar.jpeg")!, status: "Guest")
    
    func userInfo(name: String) -> User? {
        if name == user.name  {return user}
        else {return User(name: "Test", avatar: UIImage(named: "GuestAvatar.jpeg")!, status: "Test")}
    }
}
