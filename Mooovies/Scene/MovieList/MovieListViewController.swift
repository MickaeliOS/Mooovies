//
//  MovieListViewController.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import UIKit

protocol MovieListViewControllerProtocol: AnyObject {
    func presentData(viewModel: [MovieListEntity]?)
    func presentError(message: String)
}

class MovieListViewController: UIViewController {
    var interactor: MovieListInteractorProtocol?
    var router: MovieListRouterProtocol?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: "MovieListTableViewCell")
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search a Movie"
        return searchBar
    }()

    private var movieList: [MovieListEntity]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
}

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
    func presentData(viewModel: [MovieListEntity]?) {
        movieList = viewModel
    }

    func presentError(message: String) {
        presentAlert(with: message)
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text: \(searchText)")
        // Handle search text change
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // Handle search button click
    }
}
