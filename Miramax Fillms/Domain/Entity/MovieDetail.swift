//
//  MovieDetail.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

struct MovieDetail: Equatable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let genres: [Genre]
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let runtime: Int?
    let credits: Credit?
    let recommendations: MovieResponse?
}
