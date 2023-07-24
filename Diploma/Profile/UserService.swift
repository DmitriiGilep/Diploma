//
//  UserService.swift
//  Industrial
//
//  Created by DmitriiG on 04.08.2022.
//

import Foundation
import UIKit

protocol UserService {
    
    func userInfo(name: String) -> User?
    
}

