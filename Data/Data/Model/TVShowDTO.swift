//
//  TVShowDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import ObjectMapper
import Domain

public struct TVShowDTO : Mappable {
    public var id: Int = 0
    public var name: String = ""
    public var overview: String = ""
    public var voteAverage: Double = 0.0
    public var firstAirDate: String = ""
    public var backdropPath: String?
    public var posterPath: String?
    public var genres: [GenreDTO]?
    public var numberOfEpisodes: Int?
    public var numberOfSeasons: Int?
    public var seasons: [SeasonDTO]?
    public var credits: CreditDTO?
    public var backdropImages: [ImageDTO]?
    public var videos: [VideoDTO]?
    public var recommendations: TVShowResponseDTO?
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        overview <- map["overview"]
        voteAverage <- map["vote_average"]
        firstAirDate <- map["first_air_date"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        genres <- map["genres"]
        numberOfEpisodes <- map["number_of_episodes"]
        numberOfSeasons <- map["number_of_seasons"]
        seasons <- map["seasons"]
        credits <- map["credits"]
        backdropImages <- map["images.backdrops"]
        videos <- map["videos.results"]
        recommendations <- map["recommendations"]
    }
}

extension TVShowDTO: DomainConvertibleType {
    public func asDomain() -> TVShow {
        return TVShow(id: id, name: name, overview: overview, voteAverage: voteAverage, firstAirDate: firstAirDate, backdropPath: backdropPath, posterPath: posterPath, genres: genres?.map { $0.asDomain() }, numberOfEpisodes: numberOfEpisodes, numberOfSeasons: numberOfSeasons, seasons: seasons?.map { $0.asDomain() }, credits: credits?.asDomain(), backdropImages: backdropImages?.map { $0.asDomain() }, videos: videos?.map { $0.asDomain() }, recommendations: recommendations?.asDomain())
    }
}

