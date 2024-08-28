//
//  MovieListPresenter.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import Foundation

protocol MovieListPresenterProtocol: AnyObject {
    func presentPopularMovies(movieList: [Movie], currentPage: Int)
    func presentSearchedMovies(movieList: [Movie], currentPage: Int)
    func presentError(message: String)
    func presentNextPage(movieList: [Movie], currentPage: Int)
}

final class MovieListPresenter {
    weak var viewController: MovieListViewControllerProtocol?
}

extension MovieListPresenter: MovieListPresenterProtocol {
    func presentPopularMovies(movieList: [Movie], currentPage: Int) {
        viewController?.presentPopularMovies(movieList: movieList, currentPage: currentPage)
    }

    func presentSearchedMovies(movieList: [Movie], currentPage: Int) {
        viewController?.presentSearchedMovies(movieList: movieList, currentPage: currentPage)
    }

    func presentError(message: String) {
        viewController?.presentError(message: message)
    }

    func presentNextPage(movieList: [Movie], currentPage: Int) {
        viewController?.presentNextPage(viewModel: movieList, currentPage: currentPage)
    }
}
