//
//  PersonDetail.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import Foundation

public struct PersonDetail {
    public let id: Int
    public let name: String
    public let birthday: String?
    public let biography: String?
    public let profilePath: String?
    public let images: [Image]
    public let departments: [String]
    public let castMovies: [Movie]
    public let castTVShows: [TVShow]
    
    public init(id: Int, name: String, birthday: String?, biography: String?, profilePath: String?, images: [Image], departments: [String], castMovies: [Movie], castTVShows: [TVShow]) {
        self.id = id
        self.name = name
        self.birthday = birthday
        self.biography = biography
        self.profilePath = profilePath
        self.images = images
        self.departments = departments
        self.castMovies = castMovies
        self.castTVShows = castTVShows
    }
}

extension PersonDetail: ImageConfigurable {
    public var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        let urlString = regularImageBaseURLString.appending(profilePath)
        return URL(string: urlString)
    }
}

extension PersonDetail {
    public var castEntertainments: [EntertainmentModelType] {
        return castMovies + castTVShows
    }
}
