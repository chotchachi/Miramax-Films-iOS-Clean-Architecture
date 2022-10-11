//
//  BookmarkEntertainment.swift
//  Domain
//
//  Created by Thanh Quang on 09/10/2022.
//

import Foundation

public struct BookmarkEntertainment: EntertainmentModelType {
    public let id: Int
    public let name: String
    public let overview: String
    public let rating: Double
    public let releaseDate: String
    public let backdropPath: String?
    public let posterPath: String?
    public let type: EntertainmentType
    public let createAt: Date
    
    public init(id: Int, name: String, overview: String, rating: Double, releaseDate: String, backdropPath: String?, posterPath: String?, type: EntertainmentType, createAt: Date) {
        self.id = id
        self.name = name
        self.overview = overview
        self.rating = rating
        self.releaseDate = releaseDate
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.type = type
        self.createAt = createAt
    }
}
