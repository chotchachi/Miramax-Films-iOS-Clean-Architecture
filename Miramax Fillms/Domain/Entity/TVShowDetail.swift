//
//  TVShowDetail.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

struct TVShowDetail: Equatable {
    let id: Int
    let name: String
    let backdropPath: String?
    let posterPath: String?
    let genres: [Genre]
    let overview: String
    let firstAirDate: String
    let voteAverage: Double
    let episodeRuntime: [Int]
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let seasons: [Season]
    let credits: Credit?
    let recommendations: TVShowResponse?
}

extension TVShowDetail: ImageConfigurable {
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        let urlString = backdropImageBaseURLString.appending(backdropPath)
        return URL(string: urlString)
    }
}

extension TVShowDetail {
    var directors: [Crew] {
        guard let credits = credits else { return [] }
        return credits.crew.filter { $0.job == "Director" }
    }
    
    var writers: [Crew] {
        guard let credits = credits else { return [] }
        return credits.crew.filter { $0.job == "Screenplay" || $0.job == "Writer" }
    }
}

extension TVShowDetail: EntertainmentDetailModelType {
    var entertainmentDetailTitle: String {
        return name
    }
    
    var entertainmentPosterURL: URL? {
        return posterURL
    }
    
    var entertainmentVoteAverage: Double {
        return voteAverage
    }
    
    var entertainmentRuntime: Int? {
        return nil
    }
    
    var entertainmentReleaseDate: String {
        return firstAirDate
    }
    
    var entertainmentOverview: String {
        return overview
    }
    
    var entertainmentDirectors: [Crew] {
        return directors
    }
    
    var entertainmentWriters: [Crew] {
        return writers
    }
    
    var entertainmentCasts: [Cast] {
        return credits?.cast ?? []
    }
    
    var entertainmentRecommends: [EntertainmentModelType] {
        return recommendations?.results ?? []
    }
}
