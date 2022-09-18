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
    var originalName: String!
    var originalLanguage: String!
    var backdropPath: String?
    var posterPath: String?
    var genreIDS: [Int]!
    var overview: String!
    var popularity: Double!
    var voteAverage: Double!
    var voteCount: Int!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        originalName <- map["original_name"]
        originalLanguage <- map["original_language"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        genreIDS <- map["genre_ids"]
        overview <- map["overview"]
        popularity <- map["popularity"]
        voteAverage <- map["vote_average"]
        voteCount <- map["vote_count"]
    }
}

extension TVShowDTO: DomainConvertibleType {
    func asDomain() -> TVShow {
        return TVShow(id: id, name: name, originalName: originalName, originalLanguage: originalLanguage, backdropPath: backdropPath, posterPath: posterPath, genreIDS: genreIDS, overview: overview, popularity: popularity, voteAverage: voteAverage, voteCount: voteCount)
    }
}

