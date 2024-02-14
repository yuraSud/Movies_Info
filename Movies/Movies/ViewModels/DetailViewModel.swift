//
//  DetailViewModel.swift
//  Movies
//
//  Created by Olga Sabadina on 03.02.2024.
//

import Foundation
import Combine

class DetailViewModel {
    
    @Published var error: Error?
    @Published var isLoadData = false
    
    var headerData: MainSectionModel = .init()
    var castArray = [MovieCellModel]()
    var recommendations = [MovieCellModel]()
    var mediaSection = [MovieCellModel]()
    let model: MovieCellModel
    
    private var cancellable = Set<AnyCancellable>()
    private let networkManager = NetworkManager()
    
    init(model: MovieCellModel) {
        self.model = model
        fetchMovieModel()
        fetchRecommendationMovies()
        fetchCastMovies()
        sinkToError()
        Task{
           try await createMoviesArrayModels()
        }
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
    
    private func fetchMovieModel() {
        networkManager.fetchMovies(urlString: URLBuilder.movie(id: model.idMovie ?? 0), type: Movie.self)
            .sink { сompletion in
                switch сompletion {
                case .finished:
                   break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { movie in
                self.createMovieModel(movie)
                self.isLoadData = true
            }
            .store(in: &cancellable)
    }
    
    private func createMovieModel(_ movie: Movie ) {
        fetchVideoUrl { key in
            self.headerData = MainSectionModel(titleName: movie.title,
                                               duration: movie.runtime,
                                               channelTitle: movie.nameChannel,
                                               percentTitle: self.model.percentTitle,
                                               yearMovie: movie.releaseDate,
                                               videoURLString: key,
                                               genteType: movie.genresArray,
                                               descriptionHeader: movie.overview,
                                               percent: self.model.percent,
                                               imageURL: URLBuilder.imageUrl(movie.posterPath)
            )
        }
        
    }
    
    func fetchRecommendationMovies() {
        networkManager.fetchMovies(urlString: URLBuilder.getRecommendationMovies(id: model.idMovie ?? 0), type: MainResultsMovies.self)
            .sink { сompletion in
                switch сompletion {
                case .finished:
                    self.isLoadData = true
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { movies in
                self.recommendations = self.createMoviesArrayModels(movies)
            }
            .store(in: &cancellable)
    }
    
    private func createMoviesArrayModels(_ data: MainResultsMovies) -> [MovieCellModel] {
        guard let resultsArray = data.movies else { return [] }
        
        var arrayMovies = [MovieCellModel]()
        
        for item in resultsArray {
            
            let cellModel = MovieCellModel(imageUrl: URLBuilder.imageUrl(item.posterPath), title: item.title, description: item.overview, percent: item.percent, idMovie: item.id, releaseData: item.releaseDate)
            
            arrayMovies.append(cellModel)
        }
        return arrayMovies
    }
    
    func fetchVideoUrl(completion: @escaping (String)-> Void) {
        
        guard let id = model.idMovie else { return }

        networkManager.fetchMovies(urlString: URLBuilder.videoKey(for: id), type: VideoModel.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { model in
                guard let key = model.results.first?.key else { return }
                completion(key)
            }
            .store(in: &cancellable)
    }
    
    func fetchCastMovies() {
        
        guard let id = model.idMovie else { return }
        
        networkManager.fetchMovies(urlString: URLBuilder.castMovie(id: id), type: CastModel.self)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoadData = true
                case .failure( let error):
                    self.error = error
                }
            } receiveValue: { cast in
                self.castArray =  self.getAllCast(cast)
            }
            .store(in: &cancellable)
    }
    
    private func getAllCast(_ result: CastModel) -> [MovieCellModel] {
        var arrayCasts = [MovieCellModel]()
        
        for item in result.cast {
            let cellModel = MovieCellModel(imageUrl: URLBuilder.imageUrl(item.profilePath), title: item.name, asHeroInFilm: item.character, genderPersone: item.genderCast, idPersone: item.id)
            
            arrayCasts.append(cellModel)
        }
        return arrayCasts
    }
    
    private func createMoviesArrayModels() async throws {
        
        guard let id = model.idMovie else { return }
        
        var arrayMovies = [MovieCellModel]()
        
        let imageUrl = try await getImageURLPath(id: id)
        
        let cellModel = MovieCellModel(idMovie: id, imageFullHDUrl: imageUrl)
        
        arrayMovies.append(cellModel)
        
        self.mediaSection = arrayMovies
        self.isLoadData = true
    }
    
    private func getImageURLPath(id: Int?) async throws -> String? {
        
        guard let id, let urlString = URL(string: URLBuilder.imageMovie(id: id)) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: urlString)
        
        let imageModels = try JSONDecoder().decode(ImageFullModel.self, from: data)
        let item = imageModels.backdrops.first { item in
            item.height < 1100
        }
        return URLBuilder.imageUrl(item?.filePath)
    }
}
