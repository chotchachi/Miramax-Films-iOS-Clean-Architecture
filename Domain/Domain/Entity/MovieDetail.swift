//
//  MovieDetail.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

public  struct MovieDetail: Equatable {
    let id: Int
    public let title: String
    public let backdropPath: String?
    public let posterPath: String?
    public let genres: [Genre]
    public let overview: String
    public let releaseDate: String
    public let voteAverage: Double
    public let runtime: Int?
    public let credits: Credit?
    public let recommendations: MovieResponse?
    
    public init(id: Int, title: String, backdropPath: String?, posterPath: String?, genres: [Genre], overview: String, releaseDate: String, voteAverage: Double, runtime: Int?, credits: Credit?, recommendations: MovieResponse?) {
        self.id = id
        self.title = title
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.genres = genres
        self.overview = overview
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.runtime = runtime
        self.credits = credits
        self.recommendations = recommendations
    }
}

extension MovieDetail: ImageConfigurable {
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

extension MovieDetail {
    public var directors: [Crew] {
        guard let credits = credits else { return [] }
        return credits.crew.filter { $0.job == "Director" }
    }
    
    public var writers: [Crew] {
        guard let credits = credits else { return [] }
        return credits.crew.filter { $0.job == "Screenplay" || $0.job == "Writer" }
    }
}

extension MovieDetail: EntertainmentDetailModelType {
    public var entertainmentModelType: EntertainmentType {
        return .movie
    }
    
    public var entertainmentDetailTitle: String {
        return title
    }
    
    public var entertainmentPosterURL: URL? {
        return posterURL
    }
    
    public var entertainmentVoteAverage: Double {
        return voteAverage
    }
    
    public var entertainmentRuntime: Int? {
        return runtime
    }
    
    public var entertainmentReleaseDate: String {
        return releaseDate
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
        return nil
    }
}
