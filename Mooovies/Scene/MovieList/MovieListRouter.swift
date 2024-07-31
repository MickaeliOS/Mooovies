//
//  MovieListRouter.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import Foundation
import UIKit

protocol MovieListRouterProtocol: AnyObject {
    func navigateToMovieDetails(with indexPath: IndexPath)
}

class MovieListRouter {
    weak var viewController: MovieListViewController?
}

extension MovieListRouter: MovieListRouterProtocol {
    func navigateToMovieDetails(with indexPath: IndexPath) {
        guard let movieDetailVC = passDataToMovieDetails(with: indexPath) else {
            return
        }

        viewController?.navigationController?.pushViewController(movieDetailVC, animated: true)
    }

    private func passDataToMovieDetails(with indexPath: IndexPath) -> UIViewController? {
        guard let movie = viewController?.popularMovieList[indexPath.row] else {
            return nil
        }

        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movie = movie
        return movieDetailVC
    }
}
