//
//  VideoModel.swift
//  Movies
//
//  Created by Olga Sabadina on 04.02.2024.
//
import Foundation

// MARK: - Recommendations
struct VideoModel: Codable {
    let id: Int
    let results: [Video]
}

// MARK: - Result
struct Video: Codable {
    let name, key: String
    
    enum CodingKeys: String, CodingKey {
        case name, key
    }
}
