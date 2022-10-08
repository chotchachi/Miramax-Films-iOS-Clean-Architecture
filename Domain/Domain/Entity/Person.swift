//
//  Person.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

public struct Person: PersonModelType {
    public let id: Int
    public let name: String
    public let profilePath: String?
    public let birthday: String?
    public let biography: String?
    public let images: [Image]?
    public let departments: [String]?
    public let castMovies: [Movie]?
    public let castTVShows: [TVShow]?
    
    public init(id: Int, name: String, profilePath: String?, birthday: String?, biography: String?, images: [Image]?, departments: [String]?, castMovies: [Movie]?, castTVShows: [TVShow]?) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
        self.birthday = birthday
        self.biography = biography
        self.images = images
        self.departments = departments
        self.castMovies = castMovies
        self.castTVShows = castTVShows
    }
}

extension Person {
    public var castEntertainments: [EntertainmentModelType] {
        return (castMovies ?? []) + (castTVShows ?? [])
    }
}
