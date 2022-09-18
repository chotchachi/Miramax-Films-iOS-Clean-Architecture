//
//  TVShow.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

struct TVShow {
    let id: Int
    let name: String
    let originalName: String
    let originalLanguage: String
    let backdropPath: String?
    let posterPath: String?
    let genreIDS: [Int]
    let overview: String
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
}

extension TVShow: Equatable {
    static func == (lhs: TVShow, rhs: TVShow) -> Bool {
        return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.originalName == rhs.originalName
        && lhs.originalLanguage == rhs.originalLanguage
        && lhs.backdropPath == rhs.backdropPath
        && lhs.genreIDS == rhs.genreIDS
        && lhs.overview == rhs.overview
        && lhs.popularity == rhs.popularity
        && lhs.voteAverage == rhs.voteAverage
        && lhs.voteCount == rhs.voteCount
    }
}

extension TVShow: ImageConfigurable {
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
