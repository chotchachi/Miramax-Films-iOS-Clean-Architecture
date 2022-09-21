//
//  MovieDetail.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

struct MovieDetail: Equatable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let genres: [Genre]
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let runtime: Int?
    let credits: Credit?
    let recommendations: MovieResponse?
}

extension MovieDetail: ImageConfigurable {
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

extension MovieDetail {
    var directors: [Crew] {
        guard let credits = credits else { return [] }
        return credits.crew.filter { $0.job == "Director" }
    }
    
    var writers: [Crew] {
        guard let credits = credits else { return [] }
        return credits.crew.filter { $0.job == "Screenplay" || $0.job == "Writer" }
    }
}

extension MovieDetail: EntertainmentDetailModelType {
    var entertainmentDetailTitle: String {
        return title
    }
    
    var entertainmentPosterURL: URL? {
        return posterURL
    }
    
    var entertainmentVoteAverage: Double {
        return voteAverage
    }
    
    var entertainmentRuntime: Int? {
        return runtime
    }
    
    var entertainmentReleaseDate: String {
        return releaseDate
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
    
    var entertainmentSeasons: [Season]? {
        return nil
    }
}
