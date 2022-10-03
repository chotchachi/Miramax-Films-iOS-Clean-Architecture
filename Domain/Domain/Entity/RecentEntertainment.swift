//
//  RecentEntertainment.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import Foundation

public struct RecentEntertainment: Equatable {
    public let id: Int
    public let name: String
    public let posterPath: String?
    public let type: EntertainmentType
    
    public init(id: Int, name: String, posterPath: String?, type: EntertainmentType) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.type = type
    }
}

extension RecentEntertainment: ImageConfigurable {
    public var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}

extension RecentEntertainment: EntertainmentModelType {
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
        return ""
    }
    
    public var entertainmentModelPosterURL: URL? {
        return posterURL
    }
    
    public var entertainmentModelBackdropURL: URL? {
        return nil
    }
    
    public var entertainmentModelRating: Double? {
        return nil
    }
}

