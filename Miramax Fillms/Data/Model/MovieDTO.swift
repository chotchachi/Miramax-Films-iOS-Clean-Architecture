//
//  MovieDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import ObjectMapper

struct MovieDTO : Mappable {
    var id: Int = 0
    var title: String = ""
    var backdropPath: String?
    var posterPath: String?
    var overview: String = ""
    var voteAverage: Double = 0
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        overview <- map["overview"]
        voteAverage <- map["vote_average"]
    }
}

extension MovieDTO: DomainConvertibleType {
    func asDomain() -> Movie {
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

