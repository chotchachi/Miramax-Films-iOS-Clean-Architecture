//
//  BookmarkPerson.swift
//  Domain
//
//  Created by Thanh Quang on 08/10/2022.
//

import Foundation

public struct BookmarkPerson: PersonModelType {
    public let id: Int
    public let name: String
    public let profilePath: String?
    public let birthday: String?
    public let biography: String?
    public let createAt: Date
    
    public init(id: Int, name: String, profilePath: String?, birthday: String?, biography: String?, createAt: Date) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
        self.birthday = birthday
        self.biography = biography
        self.createAt = createAt
    }
}
