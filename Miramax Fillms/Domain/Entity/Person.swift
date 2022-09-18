//
//  Person.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

struct Person {
    let id: Int
    let name: String
    let profilePath: String?
    let popularity: Double
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.profilePath == rhs.profilePath
        && lhs.popularity == rhs.popularity
    }
}

extension Person: ImageConfigurable {
    var profileURL: URL? {
        guard let posterPath = profilePath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}
