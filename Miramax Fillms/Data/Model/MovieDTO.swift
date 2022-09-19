//
//  MovieDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import ObjectMapper

struct MovieDTO : Mappable {
    var id: Int!
    var title: String!
    var backdropPath: String?
    var posterPath: String?
    var genreIDS: [Int]!
    var overview: String!
    var releaseDate: String!
    var voteAverage: Double!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        genreIDS <- map["genre_ids"]
        overview <- map["overview"]
        releaseDate <- map["release_date"]
        voteAverage <- map["vote_average"]
    }
}

extension MovieDTO: DomainConvertibleType {
    func asDomain() -> Movie {
        return Movie(id: id, title: title, backdropPath: backdropPath, posterPath: posterPath, genreIDS: genreIDS, overview: overview, releaseDate: releaseDate, voteAverage: voteAverage)
    }
}

