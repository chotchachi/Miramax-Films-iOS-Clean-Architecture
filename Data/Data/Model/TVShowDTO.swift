//
//  TVShowDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import ObjectMapper
import Domain

public struct TVShowDTO : Mappable {
    public var id: Int = 0
    public var name: String = ""
    public var backdropPath: String?
    public var posterPath: String?
    public var overview: String = ""
    public var voteAverage: Double = 0.0
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        overview <- map["overview"]
        voteAverage <- map["vote_average"]
    }
}

extension TVShowDTO: DomainConvertibleType {
    public func asDomain() -> TVShow {
        return TVShow(
            id: id,
            name: name,
            backdropPath: backdropPath,
            posterPath: posterPath,
            overview: overview,
            voteAverage: voteAverage
        )
    }
}

