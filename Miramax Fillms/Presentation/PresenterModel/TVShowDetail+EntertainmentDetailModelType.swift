//
//  TVShowDetail+EntertainmentDetailModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/09/2022.
//

import Foundation

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
