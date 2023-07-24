//
//  JasonModel.swift
//  Industrial
//
//  Created by DmitriiG on 13.10.2022.
//

import Foundation

struct Molestiae: Codable {
    
    let userId: Int
    let id: Int
    let title: String
    let status: Bool
    
    enum CodingKeys: String, CodingKey {
        case userId, id, title
        case status = "completed" // привожу к camelCase, хотя здесь не используется
    }
}

struct Tatooine: Codable {
    
    let name: String
    let rotationPeriod: String
    let orbitalPeriod: String
    let diameter: String
    let climate: String
    let gravity: String
    let terrain: String
    let surface_water: String
    let population: String
    let residents: [String]
    let films: [String]
    let created: String
    let edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, diameter, climate, gravity, terrain, surface_water, population, residents, films, created, edited, url
        case rotationPeriod = "rotation_period" // привожу к camelCase
        case orbitalPeriod = "orbital_period" // аналогично
        
    }
    
}

struct Residents: Codable {
    let name: String
}
