//
//  MovieListRouter.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import Foundation

protocol MovieListRouterProtocol: AnyObject {
}

class MovieListRouter {
    weak var controller: MovieListViewController?
}

extension MovieListRouter: MovieListRouterProtocol {

}
