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
    var originalTitle: String!
    var originalLanguage: String!
    var backdropPath: String?
    var posterPath: String?
    var genreIDS: [Int]!
    var overview: String!
    var releaseDate: String!
    var popularity: Double!
    var video: Bool!
    var voteAverage: Double!
    var voteCount: Int!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        originalTitle <- map["original_title"]
        originalLanguage <- map["original_language"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        genreIDS <- map["genre_ids"]
        overview <- map["overview"]
        releaseDate <- map["release_date"]
        popularity <- map["popularity"]
        video <- map["video"]
        voteAverage <- map["vote_average"]
        voteCount <- map["vote_count"]
    }
}

extension MovieDTO: DomainConvertibleType {
    func asDomain() -> Movie {
        return Movie(id: id, title: title, originalTitle: originalTitle, originalLanguage: originalLanguage, backdropPath: backdropPath, posterPath: posterPath, genreIDS: genreIDS, overview: overview, releaseDate: releaseDate, popularity: popularity, video: video, voteAverage: voteAverage, voteCount: voteCount)
    }
}

