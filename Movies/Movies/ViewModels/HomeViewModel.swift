//
//  HomeViewModel.swift
//  Movies
//
//  Created by Olga Sabadina on 09.01.2024.
//

import UIKit
import Combine

class HomeViewModel {
    
    @Published var error: Error?
    @Published var shouldReloadCollection = false
    @Published var segmentSectionsIndex: [String:Int] = [:]
    @Published var seeAllSectionDictionary: [String:Bool] = [:]
    @Published var seeAllSectionType: HomeSectionType = .categories
    
    var popularMoviesArray: [MovieCellModel] = []
    var upcomingMoviesArray: [MovieCellModel] = []
    var latestMoviesArray: [MovieCellModel] = []
    var trendingMoviesArray: [MovieCellModel] = []
    
    private let networkManager: NetworkProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(_ networkManager: NetworkProtocol) {
        self.networkManager = networkManager
        fatchPopularMovies()
        fetchLatestMovies()
        fatchFreeToWatchMovies()
        fetchTrendingMovies()
        sinkToError()
    }
    
    //MARK: - fatchPopularMovies
    
    private func sinkToError() {
        $error
            .filter{$0 != nil}
            .compactMap{$0}
            .sink { error in
                Task {
                    do {
                        try await DatabaseService.shared.uploadErrorToServer(error: error)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    private func fatchPopularMovies() {
        networkManager.fetchMovies(urlString: URLBuilder.popularMovies(), type: MainResultsMovies.self)
               .sink { сompletion in
                   switch сompletion {
                   case .finished:
                       self.shouldReloadCollection = true
                   case .failure(let error):
                       self.error = error
                   }
               } receiveValue: { movies in
                   self.popularMoviesArray = self.createArrayModels(movies)
               }
               .store(in: &cancellable)
       }

    //MARK: - "free to watch" TMDB don't have (i use upcoming api)
    
    private func fatchFreeToWatchMovies() {
        networkManager.fetchMovies(urlString: URLBuilder.upcomingMovies(), type: MainResultsMovies.self)
               .sink { сompletion in
                   switch сompletion {
                   case .finished:
                       self.shouldReloadCollection = true
                   case .failure(let error):
                       self.error = error
                   }
               } receiveValue: { movies in
                   self.upcomingMoviesArray = self.createArrayModels(movies)
               }
               .store(in: &cancellable)
       }
    
    //MARK: - LatestTrailers Sections (i use nowPlayingMovies api)
    
    private func fetchLatestMovies() {
        networkManager.fetchMovies(urlString: URLBuilder.nowPlayingMovies(), type: MainResultsMovies.self)
               .sink { сompletion in
                   switch сompletion {
                   case .finished:
                      break
                   case .failure(let error):
                       self.error = error
                   }
               } receiveValue: { movies in
                   Task {
                       self.latestMoviesArray = try await self.createMoviesArrayModels(movies)
                       self.shouldReloadCollection = true
                   }
               }
               .store(in: &cancellable)
       }
    
    //MARK: - TrendingMovies
    
    func fetchTrendingMovies(_ index: Int = 0) {
        let urlString = index == 0 ? URLBuilder.trendingForDayMovies() : URLBuilder.trendingForWeekMovies()
        networkManager.fetchMovies(urlString: urlString, type: MainResultsMovies.self)
               .sink { сompletion in
                   switch сompletion {
                   case .finished:
                       self.shouldReloadCollection = true
                   case .failure(let error):
                       self.error = error
                   }
               } receiveValue: { movies in
                   self.trendingMoviesArray = self.createArrayModels(movies)
               }
               .store(in: &cancellable)
       }
    
    //MARK: - Helpers functions
    
    private func createArrayModels(_ data: MainResultsMovies) -> [MovieCellModel] {
        guard let resultsArray = data.movies else {return []}
        
        var arrayMovies = [MovieCellModel]()
        
        for item in resultsArray {
            
            let cellModel = MovieCellModel(imageUrl: item.posterFullPath, title: item.title, percent: item.percent, idMovie: item.id, releaseData: item.releaseDate)
            
            arrayMovies.append(cellModel)
        }
        return arrayMovies
    }
    
    private func createMoviesArrayModels(_ data: MainResultsMovies) async throws -> [MovieCellModel] {
        guard let resultsArray = data.movies else {return []}
        
        var arrayMovies = [MovieCellModel]()
        
        for item in resultsArray {
            
            let imageUrl = try await getImageURLPath(id: item.id)
            
            let cellModel = MovieCellModel(imageUrl: item.posterFullPath, title: item.title, percent: item.percent, idMovie: item.id, imageFullHDUrl: imageUrl, releaseData: item.releaseDate)
            
            arrayMovies.append(cellModel)
        }
        return arrayMovies
    }
    
    private func getImageURLPath(id: Int?) async throws -> String? {
        
        guard let id, let urlString = URL(string: URLBuilder.imageMovie(id: id)) else { throw URLError(.badURL)}
        let (data, _) = try await URLSession.shared.data(from: urlString)

        let imageModels = try JSONDecoder().decode(ImageFullModel.self, from: data)
        let item = imageModels.backdrops.first { item in
            item.height < 1100
        }
        return URLBuilder.imageUrl(item?.filePath)
    }
    
    //MARK: - builder of Sections
    
    func nuberOfSection() -> Int {
        HomeSectionType.allCases.count
    }
    
    func numberItemsInSections(section: Int) -> Int {
        switch section {
        case 0:
            return HomeSectionType.categoriesTitle.count
        case 1:
            return popularMoviesArray.count
        case 2:
            return upcomingMoviesArray.count
        case 3:
            return latestMoviesArray.count
        case 4:
            return trendingMoviesArray.count
        default:
            return 0
        }
    }
}
