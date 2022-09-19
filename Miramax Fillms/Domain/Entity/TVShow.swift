//
//  TVShow.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

struct TVShow: Equatable {
    let id: Int
    let name: String
    let backdropPath: String?
    let posterPath: String?
    let genreIDS: [Int]
    let overview: String
    let voteAverage: Double
    let voteCount: Int
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
