//
//  HeaderData.swift
//  Movies
//
//  Created by Olga Sabadina on 26.01.2024.
//

import Foundation

struct HeaderData {
    let title: String
    let type: HeaderType
    var review = 0
    var discussions = 0
    var videos = 0
    var backDrops = 0
}

enum HeaderType {
    case simple, middle, full
}
