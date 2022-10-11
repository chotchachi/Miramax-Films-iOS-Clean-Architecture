//
//  TVShow.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

public struct TVShow: EntertainmentModelType {
    public let id: Int
    public let name: String
    public let overview: String
    public let voteAverage: Double
    public let firstAirDate: String
    public let backdropPath: String?
    public let posterPath: String?
    public let genres: [Genre]?
    public let numberOfEpisodes: Int?
    public let numberOfSeasons: Int?
    public let seasons: [Season]?
    public let credits: Credit?
    public let recommendations: BaseResponse<TVShow>?
    
    public var isBookmark: Bool = false

    public init(id: Int, name: String, overview: String, voteAverage: Double, firstAirDate: String, backdropPath: String?, posterPath: String?, genres: [Genre]?, numberOfEpisodes: Int?, numberOfSeasons: Int?, seasons: [Season]?, credits: Credit?, recommendations: BaseResponse<TVShow>?) {
        self.id = id
        self.name = name
        self.overview = overview
        self.voteAverage = voteAverage
        self.firstAirDate = firstAirDate
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.genres = genres
        self.numberOfEpisodes = numberOfEpisodes
        self.numberOfSeasons = numberOfSeasons
        self.seasons = seasons
        self.credits = credits
        self.recommendations = recommendations
    }
}

extension TVShow {
    public var directors: [Crew]? {
        return credits?.crew.filter { $0.job == "Director" }
    }
    
    public var writers: [Crew]? {
        return credits?.crew.filter { $0.job == "Screenplay" || $0.job == "Writer" }
    }
    
    public var casts: [Cast]? {
        return credits?.cast
    }
}
