//
//  NetworkManager.swift
//  Movies
//
//  Created by Olga Sabadina on 23.01.2024.
//

import Foundation
import Combine

protocol NetworkProtocol {
    func fetchMovies<T:Codable>(urlString: String, type: T.Type) -> AnyPublisher<T,Error>
}

struct NetworkManager: NetworkProtocol {
    
    func fetchMovies<T:Codable>(urlString: String, type: T.Type) -> AnyPublisher<T,Error> {

        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
}
