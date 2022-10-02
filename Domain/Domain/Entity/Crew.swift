//
//  Crew.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

public struct Crew: Equatable {
    public let id: Int
    public let name: String
    public let job: String
    public let profilePath: String?
    
    public init(id: Int, name: String, job: String, profilePath: String?) {
        self.id = id
        self.name = name
        self.job = job
        self.profilePath = profilePath
    }
}

extension Crew: ImageConfigurable {
    public var profileURL: URL? {
        guard let posterPath = profilePath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}

extension Crew: PersonModelType {
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
