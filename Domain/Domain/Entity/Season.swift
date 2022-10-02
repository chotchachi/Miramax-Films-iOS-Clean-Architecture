//
//  Season.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

public struct Season: Equatable {
    public let id: Int
    public let name: String
    public let overview: String
    public let airDate: String?
    public let episodeCount: Int?
    public let posterPath: String?
    public let seasonNumber: Int
    public let episodes: [Episode]?
    
    public init(id: Int, name: String, overview: String, airDate: String?, episodeCount: Int?, posterPath: String?, seasonNumber: Int, episodes: [Episode]?) {
        self.id = id
        self.name = name
        self.overview = overview
        self.airDate = airDate
        self.episodeCount = episodeCount
        self.posterPath = posterPath
        self.seasonNumber = seasonNumber
        self.episodes = episodes
    }
}

extension Season: ImageConfigurable {
    public var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}
