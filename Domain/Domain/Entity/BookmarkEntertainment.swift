//
//  BookmarkEntertainment.swift
//  Domain
//
//  Created by Thanh Quang on 09/10/2022.
//

import Foundation

public struct BookmarkEntertainment: Equatable {
    public let id: Int
    public let name: String
    public let overview: String
    public let voteAverage: Double
    public let releaseDate: String
    public let posterPath: String?
    public let type: EntertainmentType
    public let createAt: Date
    
    public init(id: Int, name: String, overview: String, voteAverage: Double, releaseDate: String, posterPath: String?, type: EntertainmentType, createAt: Date) {
        self.id = id
        self.name = name
        self.overview = overview
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.type = type
        self.createAt = createAt
    }
}

extension BookmarkEntertainment: ImageConfigurable {
    public var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}

extension BookmarkEntertainment: EntertainmentModelType {
    public var entertainmentModelType: EntertainmentType {
        return type
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
        return releaseDate
    }
    
    public var entertainmentModelBackdropURL: URL? {
        return nil
    }
    
    public var entertainmentModelPosterURL: URL? {
        return posterURL
    }
    
    public var entertainmentModelRuntime: Int? {
        return nil
    }
    
    public var entertainmentModelDirectors: [Crew]? {
        return nil
    }
    
    public var entertainmentModelWriters: [Crew]? {
        return nil
    }
    
    public var entertainmentModelCasts: [Cast]? {
        return nil
    }
    
    public var entertainmentModelSeasons: [Season]? {
        return nil
    }
    
    public var entertainmentModelRecommends: [EntertainmentModelType]? {
        return nil
    }
    
    public var entertainmentModelIsBookmark: Bool {
        return true
    }
}

