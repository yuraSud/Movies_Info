//
//  ActorViewModel.swift
//  Movies
//
//  Created by Olga Sabadina on 04.02.2024.
//
import Combine
import Foundation

class ActorViewModel {
    
    @Published var shouldReload = false
    
    var model: MovieCellModel
    var recommendationsArray = [MovieCellModel]()
    var actingArray = [MovieCellModel]()
    
    init(model: MovieCellModel) {
        self.model = model
        prepareForShowData()
    }
    
    func prepareForShowData() {
        Task {
            model.biography = try await getBiography(idPersone: model.idPersone)
            let recommendActing = try await getActing(urlString: URLBuilder.knownFor(id: model.idPersone ?? 0))
            let actingData = try await getActing(urlString: URLBuilder.acting(id: model.idPersone ?? 0))
            recommendationsArray = getAllRecommendationMovieModels(recommendActing)
            actingArray = getAllActingMovieModels(actingData)
            shouldReload = true
        }
    }
    
    private func getBiography(idPersone: Int?) async throws -> String? {
        
        guard let idPersone, let urlString = URL(string: URLBuilder.biography(id: idPersone)) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: urlString)
        
        let biographyModels = try JSONDecoder().decode(BiographyModel.self, from: data)
        return biographyModels.translations.first?.data.biography
    }
    
    private func getActing(urlString: String) async throws -> Acting {
        
        guard let urlString = URL(string: urlString) else { throw URLError(.badURL)}
        let (data, _) = try await URLSession.shared.data(from: urlString)
        
        let acting = try JSONDecoder().decode(Acting.self, from: data)
        return acting
    }
    
    private func getAllRecommendationMovieModels(_ result: Acting) -> [MovieCellModel] {
        var arrayKnownFor = [MovieCellModel]()
        
        for item in result.cast {
            
            let cellModel = MovieCellModel(imageUrl: URLBuilder.imageUrl(item.posterPath), title: item.title, idMovie: item.id)
            
            arrayKnownFor.append(cellModel)
        }
        return arrayKnownFor
    }
    
    private func getAllActingMovieModels(_ result: Acting) -> [MovieCellModel] {
        var arrayActing = [MovieCellModel]()
        
        for item in result.cast {
            
            let cellModel = MovieCellModel(imageUrl: URLBuilder.imageUrl(item.posterPath), title: item.title, asHeroInFilm: item.character, idMovie: item.id, releaseData: item.releaseDate )
            
            arrayActing.append(cellModel)
        }
        return arrayActing
    }
}
