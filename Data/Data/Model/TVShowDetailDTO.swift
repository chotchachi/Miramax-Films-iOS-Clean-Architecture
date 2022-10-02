//
//  TVShowDetailDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/09/2022.
//

import ObjectMapper
import Domain

public struct TVShowDetailDTO : Mappable {
    public var id: Int = 0
    public var name: String = ""
    public var backdropPath: String?
    public var posterPath: String?
    public var genres: [GenreDTO] = []
    public var overview: String = ""
    public var firstAirDate: String = ""
    public var voteAverage: Double = 0.0
    public var numberOfEpisodes: Int = 0
    public var numberOfSeasons: Int = 0
    public var seasons: [SeasonDTO] = []
    public var credits: CreditDTO?
    public var recommendations: TVShowResponseDTO?
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        genres <- map["genres"]
        overview <- map["overview"]
        firstAirDate <- map["first_air_date"]
        voteAverage <- map["vote_average"]
        numberOfEpisodes <- map["number_of_episodes"]
        numberOfSeasons <- map["number_of_seasons"]
        seasons <- map["seasons"]
        credits <- map["credits"]
        recommendations <- map["recommendations"]
    }
}

extension TVShowDetailDTO: DomainConvertibleType {
    public func asDomain() -> TVShowDetail {
        return TVShowDetail(
            id: id,
            name: name,
            backdropPath: backdropPath,
            posterPath: posterPath,
            genres: genres.map { $0.asDomain() },
            overview: overview,
            firstAirDate: firstAirDate,
            voteAverage: voteAverage,
            numberOfEpisodes: numberOfEpisodes,
            numberOfSeasons: numberOfSeasons,
            seasons: seasons.map { $0.asDomain() },
            credits: credits?.asDomain(),
            recommendations: recommendations?.asDomain()
        )
    }
}
