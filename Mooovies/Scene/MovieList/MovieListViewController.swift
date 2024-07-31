//
//  MovieListViewController.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import UIKit

// MARK: - PROTOCOL
protocol MovieListViewControllerProtocol: AnyObject {
    func presentPopularMovies(movieList: [Movie], currentPage: Int)
    func presentSearchedMovies(movieList: [Movie], currentPage: Int)
    func presentError(message: String)
    func presentNextPage(viewModel: [Movie], currentPage: Int)
}

// MARK: - VC
class MovieListViewController: UIViewController {

    // MARK: PROPERTIES
    var interactor: (any MovieListInteractorProtocol)?
    var router: MovieListRouterProtocol?
    var searchingTimer: Timer?
    var searchingType = SearchType.popular

    var popularMovieList = [Movie]()
    private lazy var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: "MovieListTableViewCell")
        return tableView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search a Movie"
        return searchBar
    }()

    private var popularCurrentPage: Int?
    private var currentPage: Int?

    // MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getMovieConfiguration()
        buildUI()
    }
}

// MARK: EXTENSION
extension MovieListViewController {
    private func buildUI() {
        buildSearchBar()
        buildTableView()
    }

    private func buildTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func buildSearchBar() {
        view.addSubview(searchBar)

        searchBar.snp.makeConstraints { make in
            make.top.right.left.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MovieListViewController: MovieListViewControllerProtocol {
    func presentPopularMovies(movieList: [Movie], currentPage: Int) {
        popularMovieList = movieList
        movies = movieList
        popularCurrentPage = currentPage
        self.currentPage = currentPage
    }

    func presentSearchedMovies(movieList: [Movie], currentPage: Int) {
        movies = movieList
        self.currentPage = currentPage
    }

    func presentError(message: String) {
        presentAlert(with: message)
    }

    func presentNextPage(viewModel: [Movie], currentPage: Int) {
        if searchingType == .popular {
            popularMovieList.append(contentsOf: viewModel)
            popularCurrentPage = currentPage
        }

        movies.append(contentsOf: viewModel)
        self.currentPage = currentPage
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell", for: indexPath) as? MovieListTableViewCell else {
            return UITableViewCell()
        }

        let movie = movies[indexPath.row]

        cell.configureCell(
            movieTitle: movie.title,
            movieImageStringURL: movie.poster,
            movieNote: movie.note,
            movieGenres: movie.genres,
            movieReleaseYear: movie.releaseYear
        )

        if indexPath.row == movies.count - 1 {
            guard let currentPage = currentPage else { return UITableViewCell() }
            interactor?.getNextPage(page: currentPage + 1, searchType: searchingType)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.navigateToMovieDetails(with: indexPath)
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingTimer?.invalidate()

        if searchText.isEmpty {
            searchingType = .popular
            movies = popularMovieList
            currentPage = popularCurrentPage
        } else {
            searchingType = .userSearch
            searchingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.interactor?.searchMovies(from: searchText)
            })
        }
    }
}
