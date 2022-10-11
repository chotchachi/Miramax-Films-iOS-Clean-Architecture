//
//  RecentEntertainment.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import Foundation

public struct RecentEntertainment: EntertainmentModelType {
    public let id: Int
    public let name: String
    public let backdropPath: String?
    public let posterPath: String?
    public let type: EntertainmentType
    public let createAt: Date
    
    public init(id: Int, name: String, backdropPath: String?, posterPath: String?, type: EntertainmentType, createAt: Date) {
        self.id = id
        self.name = name
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.type = type
        self.createAt = createAt
    }
}
