//
//  MainSectionModel.swift
//  Movies
//
//  Created by Olga Sabadina on 24.01.2024.
//

import Foundation

struct MainSectionModel {
    let titleName: String?
    let duration: Int?
    let channelTitle: String?
    let percentTitle: String?
    let yearMovie: String?
    let videoURLString: String?
    let genteType: [String]?
    let descriptionHeader: String?
    let percent: Int?
    let imageURL: String?
    
    var durationTitle: String {
        timeDuration(duration)
    }
    
    init(titleName: String? = nil,
         duration: Int? = nil,
         channelTitle: String? = nil,
         percentTitle: String? = nil,
         yearMovie: String? = nil,
         videoURLString: String? = nil,
         genteType: [String]? = nil,
         descriptionHeader: String? = nil,
         percent: Int? = nil,
         imageURL: String? = nil
    ) {
        self.titleName = titleName
        self.duration = duration
        self.channelTitle = channelTitle
        self.percentTitle = percentTitle
        self.yearMovie = yearMovie
        self.videoURLString = videoURLString
        self.genteType = genteType
        self.descriptionHeader = descriptionHeader
        self.percent = percent
        self.imageURL = imageURL
    }
    
    private func timeDuration(_ value: Int?) -> String {
        guard let value else {return "0m"}
        var result = ""
        if value < 60 {
            result = "\(value)m"
        } else {
            result = calculateDuration(value)
        }
        return result
    }
    
    private func calculateDuration(_ duration: Int) -> String {
        let hours = duration / 60
        let minutes = duration - (hours * 60)
        return "\(hours)h \(minutes)m"
    }
}
