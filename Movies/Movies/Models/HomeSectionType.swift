//
//  HomeSectionType.swift
//  Movies
//
//  Created by Olga Sabadina on 04.02.2024.
//

import Foundation

enum HomeSectionType: Int, CaseIterable {
    
    static var categoriesTitle: [String] {
        ["Movies", "TV Shows", "People", "More"]
    }
    
    case categories
    case popular
    case freeWatch
    case latestTrailers
    case trending
    
    var headerTitle: String? {
        switch self {
        case .categories:
            return nil
        case .popular:
            return "What's Popular"
        case .freeWatch:
            return "Free To Watch"
        case .latestTrailers:
            return "Latest Trailers"
        case .trending:
            return "Trending"
        }
    }
    
    var headersSegments: [String] {
        switch self {
        case .categories:
            return []
        case .popular:
            return ["Streming", "On TV", "For Rent", "In Theatres  "]
        case .freeWatch:
            return ["Movies", "TV Shows"]
        case .latestTrailers:
            return ["Streming", "On TV", "For Rent", "In Theatres "]
        case .trending:
            return ["Today", "This Week"]
        }
    }
    
    var segmentKeyForIndex: String {
        switch self {
        case .categories:
            return ""
        case .popular:
            return "popular"
        case .freeWatch:
            return "freeWatch"
        case .latestTrailers:
            return "latestTrailers"
        case .trending:
            return "trending"
        }
    }
}
