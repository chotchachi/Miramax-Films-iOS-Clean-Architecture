//
//  Movie.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import Foundation

public struct Movie: EntertainmentModelType {
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
    
    public var isBookmark: Bool = false

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
    
    public func copy() -> Movie {
        return Movie(id: id, title: title, overview: overview, voteAverage: voteAverage, releaseDate: releaseDate, backdropPath: backdropPath, posterPath: posterPath, genres: genres, runtime: runtime, credits: credits, recommendations: recommendations)
    }
}

extension Movie {
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
