//
//  CreditsPresenter.swift
//  Mooovies
//
//  Created by Mickaël Horn on 21/08/2024.
//

import Foundation

protocol CreditsPresenterProtocol: AnyObject {
    func presentTMDBWebPage(url: URL)
    func presentError(message: String)
}

final class CreditsPresenter {
    weak var viewController: CreditsViewController?
}

extension CreditsPresenter: CreditsPresenterProtocol {
    func presentTMDBWebPage(url: URL) {
        viewController?.presentTMDBWebPage(url: url)
    }

    func presentError(message: String) {
        viewController?.presentError(message: message)
    }
}
