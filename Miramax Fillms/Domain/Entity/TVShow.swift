//
//  TVShow.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

struct TVShow: Equatable {
    let id: Int
    let name: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
}

extension TVShow: ImageConfigurable {
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

extension TVShow: EntertainmentModelType {
    var entertainmentModelId: Int {
        return id
    }
    
    var thumbImageURL: URL? {
        return posterURL
    }
    
    var backdropImageURL: URL? {
        return backdropURL
    }
    
    var textName: String {
        return name
    }
    
    var textDescription: String {
        return overview
    }
}
