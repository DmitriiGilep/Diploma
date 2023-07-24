//
//  CurrentUserService.swift
//  Industrial
//
//  Created by DmitriiG on 04.08.2022.
//

import Foundation
import UIKit

class CurrentUserService: UserService {
    
    var user = User(name: "Dmitrii", avatar: UIImage(named: "Avatar.jpeg")!, status: "Thinking")
    
    func userInfo(name: String) -> User? {
        if name == user.name  {return user}
        else {return User(name: name, avatar: UIImage(named: "Avatar.jpeg")!, status: "Dreaming")}
    }
}
