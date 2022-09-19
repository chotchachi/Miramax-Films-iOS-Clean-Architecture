//
//  Crew.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

struct Crew: Equatable {
    let id: Int
    let name: String
    let job: String
    let profilePath: String?
}

extension Crew: ImageConfigurable {
    var profileURL: URL? {
        guard let posterPath = profilePath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}
