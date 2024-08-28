//
//  MovieDetailViewController.swift
//  Mooovies
//
//  Created by Mickaël Horn on 10/07/2024.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: - PROPERTIES
    var movie: Movie

    // MARK: - UI PROPERTIES
    private let scrollView = UIScrollView()
    private let containerView = UIView()

    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [movieTitle, movieNote, movieGenres, movieDate, movieOverview])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()

    private var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private var movieTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        return label
    }()

    private var movieNote: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()

    private var movieGenres: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()

    private var movieDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()

    private var movieOverview: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .callout)
        textView.isEditable = false
        return textView
    }()

    // MARK: - INIT
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
        setupConstraints()
        setupMovieImage()
        setupMovieTextualInfos()
    }

    // MARK: - FUNCTIONS
    private func setupConstraints() {
        setupScrollView()
        setupMovieImageConstraints()
        setupVerticalStackViewConstraints()
    }

    private func setupScrollView() {
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }

        scrollView.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.width.height.top.bottom.equalTo(self.scrollView)
        }
    }

    private func setupMovieImageConstraints() {
        containerView.addSubview(movieImage)

        movieImage.snp.makeConstraints { make in
            make.top.equalTo(containerView).inset(20)
            make.left.right.equalTo(containerView).inset(60)
            make.height.equalTo(400)
        }
    }

    private func setupVerticalStackViewConstraints() {
        containerView.addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(movieImage.snp.bottom).offset(20)
            make.left.equalTo(containerView).inset(20)
            make.right.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView).inset(20)
        }
    }

    private func setupMovieImage() {
        movieImage.sd_setImage(with: URL(string: movie.poster ?? ""), placeholderImage: UIImage(systemName: "photo"))
    }

    private func setupMovieTextualInfos() {
        movieTitle.text = movie.title
        movieNote.text = "\(movie.note)/10"
        movieGenres.text = movie.genres
        movieDate.text = movie.releaseYear
        movieOverview.text = movie.overview
    }
}
