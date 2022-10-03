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
    public let backdropPath: String?
    public let posterPath: String?
    public let overview: String
    public let voteAverage: Double
    
    public init(id: Int, name: String, backdropPath: String?, posterPath: String?, overview: String, voteAverage: Double) {
        self.id = id
        self.name = name
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.overview = overview
        self.voteAverage = voteAverage
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
    
    public var entertainmentModelPosterURL: URL? {
        return posterURL
    }
    
    public var entertainmentModelBackdropURL: URL? {
        return backdropURL
    }
    
    public var entertainmentModelRating: Double? {
        return voteAverage
    }
}
