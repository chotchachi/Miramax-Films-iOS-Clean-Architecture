//
//  Person.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

struct Person: Equatable {
    let id: Int
    let name: String
    let profilePath: String?
}

extension Person: ImageConfigurable {
    var profileURL: URL? {
        guard let posterPath = profilePath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}

extension Person: PersonModelType {
    var personModelProfileURL: URL? {
        return profileURL
    }
    
    var personModelName: String? {
        return name
    }
}
