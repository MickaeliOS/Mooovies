//
//  MovieListEntity.swift
//  Mooovies
//
//  Created by Mickaël Horn on 08/05/2024.
//

import Foundation

// MARK: - MOVIE
struct Movie: Codable {
    let title: String
    let poster: String?
    let note: Double
    let genres: String
    let releaseYear: String
    let overview: String
    let originalLanguage: String
}

struct MovieResponse: Codable {
    let page: Int
    let results: [MovieResult]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieResult: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieResult {
    static func getYearFromStringDate(stringDate: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let releaseDate = dateFormatter.date(from: stringDate) else {
            return nil
        }

        let calendar = Calendar.current
        let currentReleaseYear = calendar.component(.year, from: releaseDate)

        return String(currentReleaseYear)
    }
}

// MARK: - IMAGE
struct TMDBConfig: Codable {
    let images: Images
    let changeKeys: [String]

    enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }
}

struct Images: Codable {
    let baseUrl: String
    let secureBaseUrl: String
    let backdropSizes: [String]
    let logoSizes: [String]
    let posterSizes: [String]
    let profileSizes: [String]
    let stillSizes: [String]

    enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url"
        case secureBaseUrl = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}

// MARK: GENRE
struct GenreResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
