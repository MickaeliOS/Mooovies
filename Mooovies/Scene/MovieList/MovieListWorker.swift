//
//  MovieListWorker.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import Foundation
import Alamofire

// MARK: PROTOCOL
protocol MovieListWorkerProtocol: AnyObject {
    associatedtype TypeOfResearch

    func getPopularMovies(completion: @escaping (Result<MovieResponse, MovieListWorkerError>) -> Void)
    func getBaseImageStringURL(completion: @escaping (TMDBConfig?) -> Void)
    func getGenreList(completion: @escaping (GenreResponse?) -> Void)
    func getNextPage(page: Int, searchType: SearchType, completion: @escaping (Result<MovieResponse, MovieListWorkerError>) -> Void)
    func searchMovies(from title: String, completion: @escaping (Result<MovieResponse, MovieListWorkerError>) -> Void)
}

final class MovieListWorker: MovieListWorkerProtocol {

    // MARK: PROPERTIES
    typealias TypeOfResearch = SearchType

    private let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = false
        return Session(configuration: configuration)
    }()

    private var popularMovieListStringURL = "https://api.themoviedb.org/3/movie/popular?api_key="
    private var searchMovieStringURL = "https://api.themoviedb.org/3/search/movie?api_key="
    private var currentSearchedMovieURL = ""
    private var baseConfigurationStringURL = "https://api.themoviedb.org/3/configuration?api_key="
    private var baseGenreStringURL = "https://api.themoviedb.org/3/genre/movie/list?api_key="

    // MARK: FUNCTIONS
    func getPopularMovies(completion: @escaping (Result<MovieResponse, MovieListWorkerError>) -> Void) {
        var movieListStringURLCopy = popularMovieListStringURL
        movieListStringURLCopy.append(APIConfiguration.apiKey)

        guard let movieListURL = URL(string: movieListStringURLCopy) else {
            completion(.failure(.badURL))
            return
        }

        session.request(movieListURL, method: .get).validate().responseDecodable(of: MovieResponse.self) { response in
            guard let data = response.value else {
                completion(.failure(.noData))
                return
            }

            if response.error != nil {
                completion(.failure(.responseKO))
            }

            completion(.success(data))
        }
    }

    func getBaseImageStringURL(completion: @escaping (TMDBConfig?) -> Void) {
        var baseConfigurationStringURLCopy = baseConfigurationStringURL
        baseConfigurationStringURLCopy.append(APIConfiguration.apiKey)

        session.request(baseConfigurationStringURLCopy, method: .get).validate().responseDecodable(of: TMDBConfig.self) { response in
            guard let data = response.value else {
                completion(nil)
                return
            }

            if response.error != nil {
                completion(nil)
            }

            completion(data)
        }
    }

    func getGenreList(completion: @escaping (GenreResponse?) -> Void) {
        var baseGenreStringURLCopy = baseGenreStringURL
        baseGenreStringURLCopy.append(APIConfiguration.apiKey)

        session.request(baseGenreStringURLCopy, method: .get).validate().responseDecodable(of: GenreResponse.self) { response in
            guard let data = response.value else {
                completion(nil)
                return
            }

            if response.error != nil {
                completion(nil)
            }

            completion(data)
        }
    }

    func getNextPage(page: Int, searchType: SearchType, completion: @escaping (Result<MovieResponse, MovieListWorkerError>) -> Void) {
        var stringURLCopy = ""

        switch searchType {
        case .userSearch:
            stringURLCopy = currentSearchedMovieURL
        case .popular:
            stringURLCopy = popularMovieListStringURL
            stringURLCopy.append(APIConfiguration.apiKey)
        }

        stringURLCopy.append("&page=\(page)")

        guard let movieListURL = URL(string: stringURLCopy) else {
            completion(.failure(.badURL))
            return
        }

        session.request(movieListURL, method: .get).validate().responseDecodable(of: MovieResponse.self) { response in
            guard let data = response.value else {
                completion(.failure(.noData))
                return
            }

            if response.error != nil {
                completion(.failure(.responseKO))
            }

            completion(.success(data))
        }
    }

    func searchMovies(from title: String, completion: @escaping (Result<MovieResponse, MovieListWorkerError>) -> Void) {
        var searchMovieStringURLCopy = searchMovieStringURL
        searchMovieStringURLCopy.append(APIConfiguration.apiKey)
        searchMovieStringURLCopy.append("&query=\(title)")

        guard let searchMovieListURL = URL(string: searchMovieStringURLCopy) else {
            completion(.failure(.badURL))
            return
        }

        session.request(searchMovieListURL, method: .get).validate().responseDecodable(of: MovieResponse.self) { [weak self] response in
            guard let data = response.value else {
                completion(.failure(.noData))
                return
            }

            if response.error != nil {
                completion(.failure(.responseKO))
            }

            self?.currentSearchedMovieURL = searchMovieStringURLCopy
            completion(.success(data))
        }
    }
}

// MARK: ENUM
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
