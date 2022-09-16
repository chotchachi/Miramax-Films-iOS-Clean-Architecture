//
//  ImageConfigurable.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

protocol ImageConfigurable {
    var regularImageBaseURLString: String { get }
    var backdropImageBaseURLString: String { get }
}

extension ImageConfigurable {
    var regularImageBaseURLString: String {
        return "https://image.tmdb.org/t/p/w185"
    }

    var backdropImageBaseURLString: String {
        return "https://image.tmdb.org/t/p/w500"
    }
}
