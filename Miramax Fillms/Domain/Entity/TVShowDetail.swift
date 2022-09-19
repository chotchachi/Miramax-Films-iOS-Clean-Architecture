//
//  TVShowDetail.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

struct TVShowDetail: Equatable {
    let id: Int
    let name: String
    let backdropPath: String?
    let posterPath: String?
    let genres: [Genre]
    let overview: String
    let firstAirDate: String
    let voteAverage: Double
    let episodeRuntime: [Int]
    let seasons: [Season]
    let credits: Credit?
    let recommendations: TVShowResponse?
}

extension TVShowDetail: ImageConfigurable {
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
