//
//  Cast.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

struct Cast: Equatable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
}

extension Cast: ImageConfigurable {
    var profileURL: URL? {
        guard let posterPath = profilePath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}

extension Cast: PersonModelType {
    var personModelProfileURL: URL? {
        return profileURL
    }
    
    var personModelName: String? {
        return name
    }
}
