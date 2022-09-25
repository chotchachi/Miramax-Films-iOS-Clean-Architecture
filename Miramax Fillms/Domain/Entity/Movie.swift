//
//  Movie.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import Foundation

struct Movie: Equatable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
}

extension Movie: ImageConfigurable {
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

extension Movie: EntertainmentModelType {
    var entertainmentModelType: EntertainmentType {
        return .movie
    }
    
    var entertainmentModelId: Int {
        return id
    }
    
    var entertainmentModelName: String {
        return title
    }
    
    var entertainmentModelOverview: String {
        return overview
    }
    
    var entertainmentModelPosterURL: URL? {
        return posterURL
    }
    
    var entertainmentModelBackdropURL: URL? {
        return backdropURL
    }
}
