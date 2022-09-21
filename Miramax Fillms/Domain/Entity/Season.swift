//
//  Season.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

struct Season: Equatable {
    let id: Int
    let name: String
    let overview: String
    let airDate: String?
    let episodeCount: Int?
    let posterPath: String?
    let seasonNumber: Int
}

extension Season: ImageConfigurable {
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}
