//
//  Cast.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

public struct Cast: Equatable {
    public let id: Int
    public let name: String
    public let character: String
    public let profilePath: String?
    
    public init(id: Int, name: String, character: String, profilePath: String?) {
        self.id = id
        self.name = name
        self.character = character
        self.profilePath = profilePath
    }
}

extension Cast: ImageConfigurable {
    public var profileURL: URL? {
        guard let posterPath = profilePath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}

extension Cast: PersonModelType {
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
