//
//  MovieListTableViewCell.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import UIKit
import SnapKit

class MovieListTableViewCell: UITableViewCell {
    private var entityImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private var label = UILabel()

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
        addSubview(entityImage)

        entityImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
    }
}
