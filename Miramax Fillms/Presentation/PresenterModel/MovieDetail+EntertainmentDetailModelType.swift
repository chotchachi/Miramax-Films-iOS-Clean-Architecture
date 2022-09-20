//
//  MovieDetail+EntertainmentDetailModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/09/2022.
//

import Foundation

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
}
