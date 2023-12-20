//
//  JasonModel.swift
//  Diploma
//
//  Created by DmitriiG on 23.08.2023.
//

import Foundation

struct ImageForAvatar: Codable {
    let message: String
}

struct Profile: Codable {
    let results: [Results]
}

struct Results: Codable {
    let name: Name
    let picture: Picture
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable {
    let large: String
}

struct Description: Codable {
    let setup: String
    let punchline: String
}
