//
//  MovieListPresenter.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import Foundation

protocol MovieListPresenterProtocol: AnyObject {
    func presentData(response: [MovieListEntity]?)
    func presentError(message: String)
}

class MovieListPresenter {
    weak var viewController: MovieListViewControllerProtocol?
}

extension MovieListPresenter: MovieListPresenterProtocol {
    func presentData(response: [MovieListEntity]?) {
        let viewModel = response
        viewController?.presentData(viewModel: viewModel)
    }

    func presentError(message: String) {
        viewController?.presentError(message: message)
    }
}
