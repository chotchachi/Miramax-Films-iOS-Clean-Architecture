//
//  PersonDetail.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import Foundation

struct PersonDetail: Equatable {
    let id: Int
    let name: String
    let birthday: String?
    let biography: String
    let profilePath: String?
    let knownForDepartment: String
    let images: [Image]
    let movies: [Movie]
    let tvShows: [TVShow]
}

extension PersonDetail: ImageConfigurable {
    var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        let urlString = regularImageBaseURLString.appending(profilePath)
        return URL(string: urlString)
    }
}
