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
    public var overview: String = ""
    public var voteAverage: Double = 0
    public var releaseDate: String = ""
    public var backdropPath: String?
    public var posterPath: String?
    public var genres: [GenreDTO]?
    public var runtime: Int?
    public var credits: CreditDTO?
    public var recommendations: MovieResponseDTO?

    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        overview <- map["overview"]
        voteAverage <- map["vote_average"]
        releaseDate <- map["release_date"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        genres <- map["genres"]
        runtime <- map["runtime"]
        credits <- map["credits"]
        recommendations <- map["recommendations"]
    }
}

extension MovieDTO: DomainConvertibleType {
    public func asDomain() -> Movie {
        return Movie(id: id, title: title, overview: overview, voteAverage: voteAverage, releaseDate: releaseDate, backdropPath: backdropPath, posterPath: posterPath, genres: genres?.map { $0.asDomain() }, runtime: runtime, credits: credits?.asDomain(), recommendations: recommendations?.asDomain())
    }
}
