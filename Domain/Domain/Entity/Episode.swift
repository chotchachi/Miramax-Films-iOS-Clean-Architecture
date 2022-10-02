//
//  Episode.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import Foundation

public struct Episode: Equatable {
    public let id: Int
    public let name: String
    public let overview: String
    public let stillPath: String?
    public let episodeNumber: Int
    public let seasonNumber: Int
    public let airDate: String
    
    public init(id: Int, name: String, overview: String, stillPath: String?, episodeNumber: Int, seasonNumber: Int, airDate: String) {
        self.id = id
        self.name = name
        self.overview = overview
        self.stillPath = stillPath
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.airDate = airDate
    }
}

extension Episode: ImageConfigurable {
    public var posterURL: URL? {
        guard let stillPath = stillPath else { return nil }
        let urlString = regularImageBaseURLString.appending(stillPath)
        return URL(string: urlString)
    }
}
