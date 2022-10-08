//
//  Movie.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import Foundation

public struct Movie: Equatable {
    public let id: Int
    public let title: String
    public let overview: String
    public let voteAverage: Double
    public let releaseDate: String
    public let backdropPath: String?
    public let posterPath: String?
    public let genres: [Genre]?
    public let runtime: Int?
    public let credits: Credit?
    public let recommendations: BaseResponse<Movie>?
    
    public init(id: Int, title: String, overview: String, voteAverage: Double, releaseDate: String, backdropPath: String?, posterPath: String?, genres: [Genre]?, runtime: Int?, credits: Credit?, recommendations: BaseResponse<Movie>?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.genres = genres
        self.runtime = runtime
        self.credits = credits
        self.recommendations = recommendations
    }
}

extension Movie: ImageConfigurable {
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

extension Movie: EntertainmentModelType {
    public var entertainmentModelType: EntertainmentType {
        return .movie
    }
    
    public var entertainmentModelId: Int {
        return id
    }
    
    public var entertainmentModelName: String {
        return title
    }
    
    public var entertainmentModelOverview: String {
        return overview
    }
    
    public var entertainmentModelRating: Double {
        return voteAverage
    }
    
    public var entertainmentModelReleaseDate: String {
        return releaseDate
    }
    
    public var entertainmentModelBackdropURL: URL? {
        return backdropURL
    }
    
    public var entertainmentModelPosterURL: URL? {
        return posterURL
    }
    
    public var entertainmentModelRuntime: Int? {
        return runtime
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
        return nil
    }
    
    public var entertainmentModelRecommends: [EntertainmentModelType]? {
        return recommendations?.results
    }
}
