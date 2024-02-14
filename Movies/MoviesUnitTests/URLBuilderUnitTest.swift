//
//  URLBuilderUnitTest.swift
//  Movies
//
//  Created by Olga Sabadina on 13.02.2024.
//

import Quick
import Nimble
@testable import Movies

class URLBuilderSpec: QuickSpec {
    
    override class func spec() {
        
        describe("URLBuilder") {
            
            it("should generate correct URLs") {
                expect(URLBuilder.api.rawValue).to(equal("&api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"))
                expect(URLBuilder.apiKey.rawValue).to(equal("?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"))
                expect(URLBuilder.base.rawValue).to(equal("https://api.themoviedb.org/3/movie"))
                expect(URLBuilder.baseForPoster.rawValue).to(equal("https://image.tmdb.org/t/p/original"))
                expect(URLBuilder.baseForTrending.rawValue).to(equal("https://api.themoviedb.org/3/trending/movie"))
                expect(URLBuilder.youtube.rawValue).to(equal("https://www.youtube.com/watch?v="))
                expect(URLBuilder.popular.rawValue).to(equal("/popular"))
                expect(URLBuilder.upcoming.rawValue).to(equal("/upcoming"))
                expect(URLBuilder.recommendation.rawValue).to(equal("/similar"))
                expect(URLBuilder.videoPath.rawValue).to(equal("/videos"))
                expect(URLBuilder.images.rawValue).to(equal("/images"))
                expect(URLBuilder.trendingForDay.rawValue).to(equal("/day"))
                expect(URLBuilder.trendingForWeek.rawValue).to(equal("/week"))
                expect(URLBuilder.nowPlaying.rawValue).to(equal("/now_playing"))
                expect(URLBuilder.castInMovie.rawValue).to(equal("/credits"))
                expect(URLBuilder.persone.rawValue).to(equal("https://api.themoviedb.org/3/person/"))
                expect(URLBuilder.biography.rawValue).to(equal("/translations"))
                expect(URLBuilder.acting.rawValue).to(equal("/movie_credits?language=en-US"))
                expect(URLBuilder.knownFor.rawValue).to(equal("/combined_credits?language=en-US"))
                expect(SearchCategories.movie.searchHeader).to(equal("https://api.themoviedb.org/3/search/movie?query="))
                expect(SearchCategories.tv.searchHeader).to(equal("https://api.themoviedb.org/3/search/tv?query="))
                expect(SearchCategories.person.searchHeader).to(equal("https://api.themoviedb.org/3/search/person?query="))
                expect(SearchCategories.company.searchHeader).to(equal("https://api.themoviedb.org/3/search/company?query="))
            }
            
            it("should generate knownFor URL correctly") {
                let id = 123
                let expectedURL = "https://api.themoviedb.org/3/person/\(id)/combined_credits?language=en-US&api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.knownFor(id: id)).to(equal(expectedURL))
            }
            
            it("should generate acting URL correctly") {
                let id = 124
                let expectedURL = "https://api.themoviedb.org/3/person/\(id)/movie_credits?language=en-US&api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.acting(id: id)).to(equal(expectedURL))
            }
            
            it("should generate biography URL correctly") {
                let id = 126
                let expectedURL = "https://api.themoviedb.org/3/person/\(id)/translations?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.biography(id: id)).to(equal(expectedURL))
            }
            
            it("should generate castMovie URL correctly") {
                let id = 127
                let expectedURL = "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.castMovie(id: id)).to(equal(expectedURL))
            }
         
            it("should generate nowPlayingMovies URL correctly") {
                let expectedURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.nowPlayingMovies()).to(equal(expectedURL))
            }
            
            it("should generate imageMovie URL correctly") {
                let id = 128
                let expectedURL = "https://api.themoviedb.org/3/movie/\(id)/images?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.imageMovie(id: id)).to(equal(expectedURL))
            }
            
            it("should generate imageUrl URL correctly") {
                let posterPath = "/posterPath"
                let expectedURL = "https://image.tmdb.org/t/p/original\(posterPath)?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.imageUrl(posterPath)).to(equal(expectedURL))
            }
            
            it("should generate popularMovies URL correctly") {
                let expectedURL = "https://api.themoviedb.org/3/movie/popular?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.popularMovies()).to(equal(expectedURL))
            }
            
            it("should generate trendingForDayMovies URL correctly") {
                let expectedURL = "https://api.themoviedb.org/3/trending/movie/day?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.trendingForDayMovies()).to(equal(expectedURL))
            }
            
            it("should generate trendingForWeekMovies URL correctly") {
                let expectedURL = "https://api.themoviedb.org/3/trending/movie/week?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.trendingForWeekMovies()).to(equal(expectedURL))
            }
            
            it("should generate upcomingMovies URL correctly") {
                let expectedURL = "https://api.themoviedb.org/3/movie/upcoming?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.upcomingMovies()).to(equal(expectedURL))
            }
            
            it("should generate movie URL correctly") {
                let id = 129
                let expectedURL = "https://api.themoviedb.org/3/movie/\(id)?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.movie(id: id)).to(equal(expectedURL))
            }
            
            it("should generate getRecommendationMovies URL correctly") {
                let movie = 129567
                let expectedURL = "https://api.themoviedb.org/3/movie/\(movie)/similar?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.getRecommendationMovies(id: movie)).to(equal(expectedURL))
            }
            
            it("should generate videoKey URL correctly") {
                let idMovie = 129567
                let expectedURL = "https://api.themoviedb.org/3/movie/\(idMovie)/videos?api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.videoKey(for: idMovie)).to(equal(expectedURL))
            }
            
            it("should generate youtubeLink URL correctly") {
                let key = "key"
                let expectedURL = "https://www.youtube.com/watch?v=\(key)"
                expect(URLBuilder.youtubeLink(key: key)).to(equal(expectedURL))
            }
            
            it("should generate findMovie URL correctly") {
                let searchType = SearchCategories.movie
                let query = "query"
                let expectedURL = "https://api.themoviedb.org/3/search/movie?query=\(query)&api_key=4eefc1a2e5e226c9176fb1fc2cd2a9d1"
                expect(URLBuilder.findMovie(searchType: searchType, query: query)).to(equal(expectedURL))
            }
        }
    }
}
