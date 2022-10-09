//
//  TVShow.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

public struct TVShow: Equatable {
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

extension TVShow: ImageConfigurable {
    public var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
    
    public var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        let urlString = backdropImageBaseURLString.appending(backdropPath)
        return URL(string: urlString)
    }
}

extension TVShow: EntertainmentModelType {
    public var entertainmentModelType: EntertainmentType {
        return .tvShow
    }
    
    public var entertainmentModelId: Int {
        return id
    }
    
    public var entertainmentModelName: String {
        return name
    }
    
    public var entertainmentModelOverview: String {
        return overview
    }
    
    public var entertainmentModelRating: Double {
        return voteAverage
    }
    
    public var entertainmentModelReleaseDate: String {
        return firstAirDate
    }
    
    public var entertainmentModelBackdropURL: URL? {
        return backdropURL
    }
    
    public var entertainmentModelPosterURL: URL? {
        return posterURL
    }
    
    public var entertainmentModelRuntime: Int? {
        return numberOfEpisodes
    }
    
    public var entertainmentModelDirectors: [Crew]? {
        return credits?.crew.filter { $0.job == "Director" }
    }
    
    public var entertainmentModelWriters: [Crew]? {
        return credits?.crew.filter { $0.job == "Screenplay" || $0.job == "Writer" }
    }
    
    public var entertainmentModelCasts: [Cast]? {
        return credits?.cast
    }
    
    public var entertainmentModelSeasons: [Season]? {
        return seasons
    }
    
    public var entertainmentModelRecommends: [EntertainmentModelType]? {
        return recommendations?.results
    }
    
    public var entertainmentModelIsBookmark: Bool {
        return isBookmark
    }
}

