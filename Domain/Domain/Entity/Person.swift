//
//  Person.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

public struct Person: Equatable {
    public let id: Int
    public let name: String
    public let profilePath: String?
    
    public init(id: Int, name: String, profilePath: String?) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
    }
}

extension Person: ImageConfigurable {
    public var profileURL: URL? {
        guard let posterPath = profilePath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}

extension Person: PersonModelType {
    public var personModelId: Int {
        return id
    }
    
    public var personModelProfileURL: URL? {
        return profileURL
    }
    
    public var personModelName: String? {
        return name
    }
}
