//
//  MovieListTableViewCell.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import UIKit
import SnapKit
import SDWebImage

protocol MovieListTableViewCellProtocol: AnyObject {
    func showGenres(genreNames: [String])
}

class MovieListTableViewCell: UITableViewCell {
    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [movieImage, verticalStackView])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()

    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [movieTitle, movieNote, movieGenres, movieDate])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()

    private lazy var cellView = UIView()

    private var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private var movieTitle = UILabel()
    private var movieNote = UILabel()
    private var movieGenres = UILabel()
    private var movieDate = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
}

extension MovieListTableViewCell {
    private func setupConstraints() {
        setupCellView()
        setupStackView()
        setupImage()
        setupLabels()
    }

    private func setupCellView() {
        contentView.addSubview(cellView)

        cellView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
    }

    private func setupStackView() {
        cellView.addSubview(horizontalStackView)

        horizontalStackView.snp.makeConstraints { make in
            make.left.equalTo(cellView.snp.left)
            make.right.equalTo(cellView.snp.right)
            make.top.equalTo(cellView.snp.top)
            make.bottom.equalTo(cellView.snp.bottom)
        }
    }

    private func setupImage() {
        movieImage.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
    }

    private func setupLabels() {
        movieTitle.font = UIFont.preferredFont(forTextStyle: .title2)
        movieNote.font = UIFont.preferredFont(forTextStyle: .headline)
        movieGenres.font = UIFont.preferredFont(forTextStyle: .caption1)
        movieDate.font = UIFont.preferredFont(forTextStyle: .caption2)

        movieTitle.numberOfLines = 0
        movieNote.numberOfLines = 0
        movieGenres.numberOfLines = 0
        movieDate.numberOfLines = 0
    }

    func configureCell(
        movieTitle: String,
        movieImageStringURL: String?,
        movieNote: Double,
        movieGenres: String,
        movieReleaseYear: String
    ) {
        self.movieImage.sd_setImage(with: URL(string: movieImageStringURL ?? ""), placeholderImage: UIImage(systemName: "photo"))
        self.movieTitle.text = movieTitle
        self.movieNote.text = "\(movieNote)/10"
        self.movieDate.text = movieReleaseYear
        self.movieGenres.text = movieGenres
    }
}

extension MovieListTableViewCell: MovieListTableViewCellProtocol {
    func showGenres(genreNames: [String]) {
        let allGenres = genreNames.joined(separator: ", ")
        self.movieGenres.text = allGenres
    }
}
