//
//  TVShowDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import ObjectMapper

struct TVShowDTO : Mappable {
    var id: Int!
    var name: String!
    var backdropPath: String?
    var posterPath: String?
    var genreIDS: [Int]!
    var overview: String!
    var voteAverage: Double!
    var voteCount: Int!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        genreIDS <- map["genre_ids"]
        overview <- map["overview"]
        voteAverage <- map["vote_average"]
        voteCount <- map["vote_count"]
    }
}

extension TVShowDTO: DomainConvertibleType {
    func asDomain() -> TVShow {
        return TVShow(id: id, name: name, backdropPath: backdropPath, posterPath: posterPath, genreIDS: genreIDS, overview: overview, voteAverage: voteAverage, voteCount: voteCount)
    }
}

