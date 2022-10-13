//
//  ImageConfigurable.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

public protocol ImageConfigurable {
    var regularImageBaseURLString: String { get }
    var backdropImageBaseURLString: String { get }
}

extension ImageConfigurable {
    public var regularImageBaseURLString: String {
        return "https://image.tmdb.org/t/p/w780"
    }
    
    public var backdropImageBaseURLString: String {
        return "https://image.tmdb.org/t/p/w1280"
    }
}

public enum PosterImageSize: String {
    case smallPreview = "w342"
    case largePreview = "w500"
    case original = "original"
}

public enum ProfileImageSize: String {
    case smallPreview = "w185"
    case largePreview = "h632"
    case original = "original"
}

public enum BackdropImageSize: String {
    case smallPreview = "w780"
    case largePreview = "w1280"
    case original = "original"
}
