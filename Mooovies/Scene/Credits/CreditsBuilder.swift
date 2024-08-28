//
//  CreditsBuilder.swift
//  Mooovies
//
//  Created by Mickaël Horn on 21/08/2024.
//

import Foundation
import UIKit

final class CreditsBuilder {
    static func build() -> UIViewController {
        let vc = CreditsViewController()
        let interactor = CreditsInteractor()
        let presenter = CreditsPresenter()

        vc.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = vc

        return vc
    }
}
