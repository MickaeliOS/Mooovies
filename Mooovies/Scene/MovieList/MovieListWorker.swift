//
//  MovieListWorker.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import Foundation
import Alamofire

protocol MovieListWorkerProtocol: AnyObject {
    func fetchMovies(completion: @escaping (Result<[MovieListEntity]?, MovieListWorkerError>) -> Void)
}

final class MovieListWorker: MovieListWorkerProtocol {
    private let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = false
        return Session(configuration: configuration)
    }()

    func fetchMovies(completion: @escaping (Result<[MovieListEntity]?, MovieListWorkerError>) -> Void) {
        var movieListURLString = "https://api.themoviedb.org/3/movie/popular?"
        movieListURLString.append(APIConfiguration.apiKey)

        guard let movieListURL = URL(string: movieListURLString) else {
            completion(.failure(.badURL))
            return
        }

        session.request(movieListURL, method: .get).validate().responseDecodable(of: [MovieListEntity]?.self) { response in
            guard let data = response.value else {
                completion(.failure(.noData))
                return
            }

            guard let error = response.error else {
                completion(.failure(.responseKO))
                return
            }

            completion(.success(data))
        }
    }
}

enum MovieListWorkerError: Error {
    case badURL
    case noData
    case responseKO

    var description: String {
        switch self {
        case .badURL, .noData, .responseKO:
            return "Error, please try again later."
        }
    }
}
