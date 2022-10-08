//
//  BookmarkPerson.swift
//  Domain
//
//  Created by Thanh Quang on 08/10/2022.
//

import Foundation

public struct BookmarkPerson: Equatable {
    public let id: Int
    public let name: String
    public let profilePath: String?
    public let createAt: Date
    
    public init(id: Int, name: String, profilePath: String?, createAt: Date) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
        self.createAt = createAt
    }
}
