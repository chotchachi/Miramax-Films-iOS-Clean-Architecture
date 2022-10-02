//
//  TVShowDetail.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

public struct TVShowDetail: Equatable {
    public let id: Int
    public let name: String
    public let backdropPath: String?
    public let posterPath: String?
    public let genres: [Genre]
    public let overview: String
    public let firstAirDate: String
    public let voteAverage: Double
    public let numberOfEpisodes: Int
    public let numberOfSeasons: Int
    public let seasons: [Season]
    public let credits: Credit?
    public let recommendations: TVShowResponse?
    
    public init(id: Int, name: String, backdropPath: String?, posterPath: String?, genres: [Genre], overview: String, firstAirDate: String, voteAverage: Double, numberOfEpisodes: Int, numberOfSeasons: Int, seasons: [Season], credits: Credit?, recommendations: TVShowResponse?) {
        self.id = id
        self.name = name
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.genres = genres
        self.overview = overview
        self.firstAirDate = firstAirDate
        self.voteAverage = voteAverage
        self.numberOfEpisodes = numberOfEpisodes
        self.numberOfSeasons = numberOfSeasons
        self.seasons = seasons
        self.credits = credits
        self.recommendations = recommendations
    }
}

extension TVShowDetail: ImageConfigurable {
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

extension TVShowDetail {
    public var directors: [Crew] {
        guard let credits = credits else { return [] }
        return credits.crew.filter { $0.job == "Director" }
    }
    
    public var writers: [Crew] {
        guard let credits = credits else { return [] }
        return credits.crew.filter { $0.job == "Screenplay" || $0.job == "Writer" }
    }
}

extension TVShowDetail: EntertainmentDetailModelType {
    public var entertainmentModelType: EntertainmentType {
        return .tvShow
    }
    
    public var entertainmentDetailTitle: String {
        return name
    }
    
    public var entertainmentPosterURL: URL? {
        return posterURL
    }
    
    public var entertainmentVoteAverage: Double {
        return voteAverage
    }
    
    public var entertainmentRuntime: Int? {
        return numberOfEpisodes
    }
    
    public var entertainmentReleaseDate: String {
        return firstAirDate
    }
    
    public var entertainmentOverview: String {
        return overview
    }
    
    public var entertainmentDirectors: [Crew]? {
        return directors.isEmpty ? nil : directors
    }
    
    public var entertainmentWriters: [Crew]? {
        return writers.isEmpty ? nil : writers
    }
    
    public var entertainmentCasts: [Cast] {
        return credits?.cast ?? []
    }
    
    public var entertainmentRecommends: [EntertainmentModelType] {
        return recommendations?.results ?? []
    }
    
    public var entertainmentSeasons: [Season]? {
        return seasons
    }
}
