//
//  RecentEntertainment.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import Foundation

struct RecentEntertainment: Equatable {
    let id: Int
    let name: String
    let posterPath: String?
    let type: EntertainmentType
}

extension RecentEntertainment: ImageConfigurable {
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}

extension RecentEntertainment: EntertainmentModelType {
    var entertainmentModelType: EntertainmentType {
        return type
    }
    
    var entertainmentModelId: Int {
        return id
    }
    
    var entertainmentModelName: String {
        return name
    }
    
    var entertainmentModelOverview: String {
        return ""
    }
    
    var entertainmentModelPosterURL: URL? {
        return posterURL
    }
    
    var entertainmentModelBackdropURL: URL? {
        return nil
    }
}

