//
//  Movie.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

struct Movie {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String?
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.adult == rhs.adult
        && lhs.backdropPath == rhs.backdropPath
        && lhs.genreIDS == rhs.genreIDS
        && lhs.id == rhs.id
        && lhs.originalLanguage == rhs.originalLanguage
        && lhs.originalTitle == rhs.originalTitle
        && lhs.overview == rhs.overview
        && lhs.popularity == rhs.popularity
        && lhs.posterPath == rhs.posterPath
        && lhs.releaseDate == rhs.releaseDate
        && lhs.title == rhs.title
        && lhs.video == rhs.video
        && lhs.voteAverage == rhs.voteAverage
        && lhs.voteCount == rhs.voteCount
    }
}
