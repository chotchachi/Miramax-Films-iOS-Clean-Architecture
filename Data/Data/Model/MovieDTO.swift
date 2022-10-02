//
//  MovieDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import ObjectMapper
import Domain

public struct MovieDTO : Mappable {
    public var id: Int = 0
    public var title: String = ""
    public var backdropPath: String?
    public var posterPath: String?
    public var overview: String = ""
    public var voteAverage: Double = 0
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        overview <- map["overview"]
        voteAverage <- map["vote_average"]
    }
}

extension MovieDTO: DomainConvertibleType {
    public func asDomain() -> Movie {
        return Movie(
            id: id,
            title: title,
            backdropPath: backdropPath,
            posterPath: posterPath,
            overview: overview,
            voteAverage: voteAverage
        )
    }
}
