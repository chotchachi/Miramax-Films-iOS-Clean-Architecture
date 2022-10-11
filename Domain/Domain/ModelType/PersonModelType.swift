//
//  PersonModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/09/2022.
//

import Foundation

public protocol PersonModelType: Equatable, ImageConfigurable {
    var profilePath: String? { get }
}

extension PersonModelType {
    public var profileURL: URL? {
        guard let posterPath = profilePath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}
