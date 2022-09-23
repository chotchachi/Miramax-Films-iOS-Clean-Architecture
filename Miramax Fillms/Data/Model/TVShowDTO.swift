//
//  TVShowDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import ObjectMapper

struct TVShowDTO : Mappable {
    var id: Int = 0
    var name: String = ""
    var backdropPath: String?
    var posterPath: String?
    var overview: String = ""
    var voteAverage: Double = 0.0
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        overview <- map["overview"]
        voteAverage <- map["vote_average"]
    }
}

extension TVShowDTO: DomainConvertibleType {
    func asDomain() -> TVShow {
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

