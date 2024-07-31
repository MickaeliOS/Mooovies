//
//  MovieListBuilder.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import Foundation
import UIKit

class MovieListBuilder {
    static func build() -> UIViewController {
        // Gets data from API
        let worker = MovieListWorker()

        let vc = MovieListViewController()

        // Interactor communicates with Worker, fetches data, and brings it to Presenter
        let interactor = MovieListInteractor(worker: worker)

        // Presenter prepares our data to be visible.
        let presenter = MovieListPresenter()
        let router = MovieListRouter()

        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        presenter.viewController = vc
        router.viewController = vc

        return vc
    }
}
