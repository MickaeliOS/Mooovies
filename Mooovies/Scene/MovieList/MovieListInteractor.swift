//
//  MovieListInteractor.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import Foundation

// MARK: PROTOCOL
protocol MovieListInteractorProtocol: AnyObject {
    associatedtype TypeOfResearch

    func getMovieConfiguration()
    func getPopularMovies()
    func getNextPage(page: Int, searchType: SearchType)
    func searchMovies(from title: String)
}

final class MovieListInteractor {
    var presenter: MovieListPresenterProtocol?
    var searchType = SearchType.userSearch
    private var worker: MovieListWorker

    init(worker: MovieListWorker) {
        self.worker = worker
    }
}

enum SearchType {
    case userSearch, popular
}

// MARK: EXTENSION
extension MovieListInteractor: MovieListInteractorProtocol {
    typealias TypeOfResearch = SearchType

    func getMovieConfiguration() {
        // We need to get the baseImageURL, to display movies's image.
        worker.getBaseImageStringURL { [weak self] config in
            guard let config else {
                return
            }

            APIConfiguration.baseImageStringURL = config.images.secureBaseUrl + (config.images.backdropSizes.contains("original") ? "original/" : "")

            // We also need the genre list, to be more specific about each movie.
            self?.worker.getGenreList { [weak self] genreResponse in
                guard let genreResponse else {
                    return
                }

                APIConfiguration.genreList = genreResponse.genres

                self?.getPopularMovies()
            }
        }
    }

    func getPopularMovies() {
        worker.getPopularMovies { [weak self] result in
            switch result {
            case .success(let movieResponse):
                guard let movies = self?.createMovies(from: movieResponse) else {
                    return
                }

                self?.presenter?.presentPopularMovies(movieList: movies, currentPage: movieResponse.page)
            case .failure(let error):
                self?.presenter?.presentError(message: error.description)
            }
        }
    }

    func getNextPage(page: Int, searchType: TypeOfResearch) {
        worker.getNextPage(page: page, searchType: searchType) { [weak self] result in
            switch result {
            case .success(let movieResponse):
                guard let movies = self?.createMovies(from: movieResponse) else {
                    return
                }

                self?.presenter?.presentNextPage(movieList: movies, currentPage: movieResponse.page)
            case .failure(let error):
                self?.presenter?.presentError(message: error.description)
            }
        }
    }

    func searchMovies(from title: String) {
        worker.searchMovies(from: title) { [weak self] result in
            switch result {
            case .success(let movieResponse):
                guard let movies = self?.createMovies(from: movieResponse) else {
                    return
                }

                self?.presenter?.presentSearchedMovies(movieList: movies, currentPage: movieResponse.page)
            case .failure(let error):
                self?.presenter?.presentError(message: error.description)
            }
        }
    }

    private func createMovies(from movieReponse: MovieResponse) -> [Movie] {
        var movies: [Movie] = []

        movieReponse.results.forEach { movieResult in
            let movieGenres = movieResult.genreIds.compactMap { genreId in
                APIConfiguration.genreList?.first { $0.id == genreId }?.name
            }.joined(separator: ", ")
            let movieNote = round(movieResult.voteAverage * 10) / 10.0
            let movieStringYearRelease = MovieResult.getYearFromStringDate(stringDate: movieResult.releaseDate)
            let imageStringURL = (APIConfiguration.baseImageStringURL ?? "") + (movieResult.posterPath ?? "")

            let movie = Movie(
                title: movieResult.title,
                poster: imageStringURL,
                note: movieNote,
                genres: movieGenres,
                releaseYear: movieStringYearRelease ?? "N/A",
                overview: movieResult.overview,
                originalLanguage: movieResult.originalLanguage
            )

            movies.append(movie)
        }

        return movies
    }
}
