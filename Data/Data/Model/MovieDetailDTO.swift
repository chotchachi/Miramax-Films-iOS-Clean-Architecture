//
//  MovieDetailDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import ObjectMapper
import Domain

public struct MovieDetailDTO : Mappable {
    public var id: Int = 0
    public var title: String = ""
    public var backdropPath: String?
    public var posterPath: String?
    public var genres: [GenreDTO] = []
    public var overview: String = ""
    public var releaseDate: String = ""
    public var voteAverage: Double = 0.0
    public var runtime: Int?
    public var credits: CreditDTO?
    public var recommendations: MovieResponseDTO?
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
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
    public func asDomain() -> MovieDetail {
        return MovieDetail(
            id: id,
            title: title,
            backdropPath: backdropPath,
            posterPath: posterPath,
            genres: genres.map { $0.asDomain() },
            overview: overview,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            runtime: runtime,
            credits: credits.map { $0.asDomain() },
            recommendations: recommendations?.asDomain()
        )
    }
}
