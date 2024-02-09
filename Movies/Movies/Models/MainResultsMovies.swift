//
//  MainResultsMovies.swift
//  Movies
//
//  Created by Olga Sabadina on 03.02.2024.
//

struct MainResultsMovies: Codable {
    let page: Int?
    let movies: [Movie]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Movie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?//OriginalLanguage?
    let originalTitle: String?
    let mediaType: MediaType?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let titleName: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let name: String?
    let runtime: Int?
    let genres: [Genre]?
    let productionCompanies: [ProductionCompany]?
    
    var percent: Int {
        Int((voteAverage ?? 0)*10)
    }
    
    var genresArray: [String] {
        var result = [String]()
        genres?.forEach { result.append($0.name) }
        return result
    }
    
    var posterFullPath: String? {
        URLBuilder.imageUrl(posterPath)
    }
    
    var nameChannel: String {
        if let productionCompanies, !productionCompanies.isEmpty {
            return productionCompanies.first?.name ?? "TV-14"
        } else {
            return "Unknow"
        }
    }
    
    var title: String {
        if let title = titleName {
            return title
        } else if let title = name {
            return title
        } else {
            return "None"
        }
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case name, genres
        case originalLanguage = "original_language"
        case productionCompanies = "production_companies"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case titleName = "title"
        case mediaType = "media_type"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case runtime
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

enum MediaType: String, Codable {
    case movie = "movie"
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case fr = "fr"
    case ko = "ko"
    case nl = "nl"
    case es = "es"
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath: String?
    let name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

