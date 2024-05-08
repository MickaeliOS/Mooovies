//
//  MovieListInteractor.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import Foundation

protocol MovieListInteractorProtocol: AnyObject {
    func fetchMovieList()
}

class MovieListInteractor {
    var presenter: MovieListPresenterProtocol?
    private var worker: MovieListWorker

    init(worker: MovieListWorker) {
        self.worker = worker
    }
}

extension MovieListInteractor: MovieListInteractorProtocol {
    func fetchMovieList() {
        worker.fetchMovies { [weak self] result in
            switch result {
            case .success(let movieList):
                self?.presenter?.presentData(response: movieList)
            case .failure(let error):
                self?.presenter?.presentError(message: error.description)
            }
        }
    }
}
