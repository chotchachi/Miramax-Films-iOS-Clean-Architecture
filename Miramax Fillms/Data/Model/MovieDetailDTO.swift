//
//  MovieDetailDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import ObjectMapper

struct MovieDetailDTO : Mappable {
    var id: Int!
    var title: String!
    var backdropPath: String?
    var posterPath: String?
    var genres: [GenreDTO]!
    var overview: String!
    var releaseDate: String!
    var voteAverage: Double!
    var runtime: Int?
    var credits: CreditDTO?
    var recommendations: MovieResponseDTO?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        genres <- map["genres"]
        overview <- map["overview"]
        releaseDate <- map["release_date"]
        voteAverage <- map["vote_average"]
        runtime <- map["runtime"]
        credits <- map["credits"]
        recommendations <- map["recommendations"]
    }
}

extension MovieDetailDTO: DomainConvertibleType {
    func asDomain() -> MovieDetail {
        return MovieDetail(id: id, title: title, backdropPath: backdropPath, posterPath: posterPath, genres: genres.map { $0.asDomain() }, overview: overview, releaseDate: releaseDate, voteAverage: voteAverage, runtime: runtime, credits: credits.map { $0.asDomain() }, recommendations: recommendations?.asDomain())
    }
}
