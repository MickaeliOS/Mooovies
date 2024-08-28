//
//  CreditsInteractor.swift
//  Mooovies
//
//  Created by Mickaël Horn on 21/08/2024.
//

import Foundation

protocol CreditsInteractorProtocol: AnyObject {
    func presentTMDBWebPage()
}

final class CreditsInteractor {
    var presenter: CreditsPresenterProtocol?
    private let tmdbURLString = "https://www.themoviedb.org"
}

extension CreditsInteractor: CreditsInteractorProtocol {
    func presentTMDBWebPage() {
        if let url = URL(string: tmdbURLString) {
            presenter?.presentTMDBWebPage(url: url)
        } else {
            presenter?.presentError(message: "An error occured during the presentation of the web page, please try again.")
        }
    }
}
