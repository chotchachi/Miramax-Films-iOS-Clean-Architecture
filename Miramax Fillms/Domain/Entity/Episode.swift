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
    let stillPath: String?
    let episodeNumber: Int
    let seasonNumber: Int
    let airDate: String
}

extension Episode: ImageConfigurable {
    var posterURL: URL? {
        guard let stillPath = stillPath else { return nil }
        let urlString = regularImageBaseURLString.appending(stillPath)
        return URL(string: urlString)
    }
}
