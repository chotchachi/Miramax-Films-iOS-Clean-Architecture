//
//  Movie.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import Foundation

struct Movie {
    let id: Int
    let title: String
    let originalTitle: String
    let originalLanguage: String
    let backdropPath: String?
    let posterPath: String?
    let genreIDS: [Int]
    let overview: String
    let releaseDate: String
    let popularity: Double
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.backdropPath == rhs.backdropPath
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

extension Movie: ImageConfigurable {
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        let urlString = backdropImageBaseURLString.appending(backdropPath)
        return URL(string: urlString)
    }
}
