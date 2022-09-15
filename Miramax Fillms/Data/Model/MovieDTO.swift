//
//  MovieDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import ObjectMapper

struct MovieDTO : Mappable {
    var adult: Bool!
    var backdropPath: String?
    var genreIDS: [Int]!
    var id: Int!
    var originalLanguage: String!
    var originalTitle: String!
    var overview: String?
    var popularity: Double!
    var posterPath: String?
    var releaseDate: String!
    var title: String!
    var video: Bool!
    var voteAverage: Double!
    var voteCount: Int!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        adult <- map["adult"]
        backdropPath <- map["backdrop_path"]
        genreIDS <- map["genre_ids"]
        id <- map["id"]
        originalLanguage <- map["original_language"]
        originalTitle <- map["original_title"]
        overview <- map["overview"]
        popularity <- map["popularity"]
        posterPath <- map["poster_path"]
        releaseDate <- map["release_date"]
        title <- map["title"]
        video <- map["video"]
        voteAverage <- map["vote_average"]
        voteCount <- map["vote_count"]
    }
}

extension MovieDTO: DomainConvertibleType {
    func asDomain() -> Movie {
        return Movie(
            adult: adult,
            backdropPath: backdropPath,
            genreIDS: genreIDS,
            id: id,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}

