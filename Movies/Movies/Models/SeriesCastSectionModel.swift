//
//  SecondSectionModel.swift
//  Movies
//
//  Created by Olga Sabadina on 25.01.2024.
//

import Foundation

struct SeriesCastSectionModel {
    let titleSection: String
    let actord: [ActorModel]
}

struct ActorModel {
    let name: String
    let photo: String
    let filmName: String
    let description: String
    let actorGender: String
}
