//
//  Episode.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import Foundation

struct Episode: Equatable {
    let id: Int
    let name: String
    let overview: String
    let runtime: Int?
    let episodeNumber: Int
    let seasonNumber: Int
    let airDate: String
    let voteAverage: Double
}
