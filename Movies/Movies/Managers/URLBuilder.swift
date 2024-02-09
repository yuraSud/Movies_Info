//
//  URLBuilder.swift
//  Movies
//
//  Created by Olga Sabadina on 02.02.2024.
//

import Foundation

enum URLBuilder: String {
    case api = "&api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
    case apiKey = "?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
    case base = "https://api.themoviedb.org/3/movie"
    case baseForPoster = "https://image.tmdb.org/t/p/original"
    case baseForTrending = "https://api.themoviedb.org/3/trending/movie"
    case youtube = "https://www.youtube.com/watch?v="
    case popular = "/popular"
    case upcoming = "/upcoming"
    case recommendation = "/similar"
    case videoPath = "/videos"
    case images = "/images"
    case trendingForDay = "/day"
    case trendingForWeek = "/week"
    case nowPlaying = "/now_playing"
    case castInMovie = "/credits"
    case persone = "https://api.themoviedb.org/3/person/"
    case biography = "/translations"
    case acting = "/movie_credits?language=en-US"
    case knownFor = "/combined_credits?language=en-US"
    
    static func knownFor(id: Int) -> String {
        persone.rawValue + "\(id)" + knownFor.rawValue + api.rawValue
        }
    
    static func acting(id: Int) -> String {
        persone.rawValue + "\(id)" + acting.rawValue + api.rawValue
        }
    
    static func biography(id: Int) -> String {
        persone.rawValue + "\(id)" + biography.rawValue + apiKey.rawValue
        }
    
    static func castMovie(id: Int) -> String {
        base.rawValue + "/\(id)" + castInMovie.rawValue + apiKey.rawValue
        }
   
    static func nowPlayingMovies() -> String {
            base.rawValue + nowPlaying.rawValue + apiKey.rawValue
        }
    
    static func imageMovie(id: Int) -> String {
        base.rawValue + "/\(id)" + images.rawValue + apiKey.rawValue
        }
    
    static func imageUrl(_ posterPath: String?) -> String? {
        guard let posterPath else { return nil }
        return baseForPoster.rawValue + posterPath + apiKey.rawValue
    }
    
    static func popularMovies() -> String {
        base.rawValue + popular.rawValue + apiKey.rawValue
    }
    
    static func trendingForDayMovies() -> String {
        baseForTrending.rawValue + trendingForDay.rawValue + apiKey.rawValue
    }
    
    static func trendingForWeekMovies() -> String {
        baseForTrending.rawValue + trendingForWeek.rawValue + apiKey.rawValue
    }
    
    static func upcomingMovies() -> String {
        base.rawValue + upcoming.rawValue + apiKey.rawValue
    }
    
    static func movie(id: Int) -> String {
        base.rawValue + "/\(id)" + apiKey.rawValue
    }
    
    static func getRecommendationMovies(id movie: Int) -> String {
        base.rawValue + "/\(movie)" + recommendation.rawValue + apiKey.rawValue
    }
    
    static func findMovie(searchType: SearchCategories, query: String) -> String {
        searchType.searchHeader + "\(query)" + api.rawValue
    }
    
    static func videoKey(for idMovie: Int) -> String {
        base.rawValue + "/\(idMovie)" + videoPath.rawValue + apiKey.rawValue
    }
    
    static func youtubeLink(key: String) -> String {
        youtube.rawValue + key
    }
    
}

enum SearchCategories: String, CaseIterable {
    case movie
    case tv
    case person
    case company
    
    var searchHeader: String {
        switch self {
        case .movie:
            return "https://api.themoviedb.org/3/search/movie?query="
        case .tv:
            return "https://api.themoviedb.org/3/search/tv?query="
        case .person:
            return "https://api.themoviedb.org/3/search/person?query="
        case .company:
            return  "https://api.themoviedb.org/3/search/company?query="
        }
    }
}
