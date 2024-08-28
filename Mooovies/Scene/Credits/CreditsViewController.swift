//
//  CreditsViewController.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import UIKit
import SafariServices

// MARK: PROTOCOL
protocol CreditsViewControllerProtocol {
    func presentTMDBWebPage(url: URL)
    func presentError(message: String)
}

class CreditsViewController: UIViewController {

    // MARK: PROPERTIES
    var interactor: CreditsInteractor?

    // MARK: UI PROPERTIES
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tmdbTitle, tmdbThanks, goToWebsiteButton])
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    private lazy var goToWebsiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TMDB Website", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)

        // Color
        button.backgroundColor = UIColor.systemGray6
        button.setTitleColor(UIColor.label, for: .normal)

        // Border
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.systemBlue.cgColor // Utilise le bleu pour contraster légèrement

        // Shadow
        button.layer.shadowColor = UIColor.white.withAlphaComponent(0.2).cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4

        button.addTarget(self, action: #selector(goToTMDBWebsite), for: .touchUpInside)

        return button
    }()

    private var tmdbTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        label.text = "The Movie Database"
        label.textAlignment = .center
        return label
    }()

    private var tmdbThanks: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.text = "This app has been built thanks to the TMDB API, check their website!"
        label.textAlignment = .center
        return label
    }()

    // MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
    }

    // MARK: FUNCTIONS
    private func setupConstraints() {
        setupStackView()
        setupButtonConstraint()
    }

    private func setupStackView() {
        view.addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerY.equalToSuperview()
        }
    }

    private func setupButtonConstraint() {
        goToWebsiteButton.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(200)
        }
    }

    @objc
    private func goToTMDBWebsite() {
        interactor?.presentTMDBWebPage()
    }
}

// MARK: EXTENSION
extension CreditsViewController: CreditsViewControllerProtocol {
    func presentTMDBWebPage(url: URL) {
        UIApplication.shared.open(url)
    }

    func presentError(message: String) {
        presentAlert(with: message)
    }
}
