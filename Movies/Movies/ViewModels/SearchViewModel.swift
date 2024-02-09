//
//  SearchViewModel.swift
//  Movies
//
//  Created by Olga Sabadina on 03.02.2024.
//

import Foundation
import Combine

class SearchViewModel {
    
    @Published var error: Error?
    @Published var isShouldReloadTable = false
    var trendingArray = [[MovieCellModel]]()
    var models = [[MovieCellModel]]()
    var cancellable = Set<AnyCancellable>()
    let networkManager = NetworkManager()
    
    init() {
        fetchTrendingMovies()
        sinkToError()
    }
    
    func fetchTrendingMovies() {
        networkManager.fetchMovies(urlString: URLBuilder.trendingForWeekMovies(), type: MainResultsMovies.self)
            .sink { сompletion in
                switch сompletion {
                case .finished:
                    self.isShouldReloadTable = true
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { movie in
                Task {
                    let result = try await self.createMoviesArrayModels(movie)
                    self.trendingArray.append(result)
                    self.isShouldReloadTable = true
                }
            }
            .store(in: &cancellable)
    }
    
    func findMovies(keyWord: String) {
        getAllSearhCategories(search: keyWord)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isShouldReloadTable = true
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { result in
                self.models = []
                result.forEach { item in
                    self.models.append(self.createArrayMovieModels(item))
                }
            }
            .store(in: &cancellable)
    }
    
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
    
    private func getAllSearhCategories(search: String) -> AnyPublisher<[MainResultsMovies],Error> {
        let categories = SearchCategories.allCases
        let publishers: [AnyPublisher<MainResultsMovies, Error>] = categories.map{findBySearchWord(searchType: $0, searchWord: search)}
        
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }
    
    private func findBySearchWord(searchType: SearchCategories, searchWord: String) -> AnyPublisher<MainResultsMovies,Error> {
        networkManager.fetchMovies(urlString: URLBuilder.findMovie(searchType: searchType, query: searchWord), type: MainResultsMovies.self)
    }
    
    private func createArrayMovieModels(_ movie: MainResultsMovies, isTrending: Bool = false) -> [MovieCellModel] {
        guard let results = movie.movies else {return []}
        
        var tempArray: [MovieCellModel] = []
        
        results.enumerated().forEach { index, item in
            if !isTrending {
                guard index < 3  else { return }
            }
                let searchModel = MovieCellModel(imageUrl: item.posterFullPath, title: item.title, description: item.overview, percent: item.percent, idMovie: item.id)
                tempArray.append(searchModel)
        }
        return tempArray
    }
    
    private func createMoviesArrayModels(_ data: MainResultsMovies) async throws -> [MovieCellModel] {
        guard let resultsArray = data.movies else {return []}
        
        var arrayMovies = [MovieCellModel]()
        
        for item in resultsArray {
            
            let imageUrl = try await getImageURLPath(id: item.id)
            
            let cellModel = MovieCellModel(imageUrl: item.posterFullPath, title: item.title, description: item.overview, percent: item.percent, idMovie: item.id, imageFullHDUrl: imageUrl, releaseData: item.releaseDate)
            
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
}
