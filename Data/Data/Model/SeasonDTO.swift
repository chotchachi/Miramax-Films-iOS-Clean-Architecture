//
//  SeasonDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/09/2022.
//

import ObjectMapper
import Domain

public struct SeasonDTO : Mappable {
    public var id: Int = 0
    public var name: String = ""
    public var overview: String = ""
    public var airDate: String?
    public var episodeCount: Int?
    public var posterPath: String?
    public var seasonNumber: Int = 0
    public var episodes: [EpisodeDTO]?
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        overview <- map["overview"]
        airDate <- map["air_date"]
        episodeCount <- map["episode_count"]
        posterPath <- map["poster_path"]
        seasonNumber <- map["season_number"]
        episodes <- map["episodes"]
    }
}

extension SeasonDTO: DomainConvertibleType {
    public func asDomain() -> Season {
        return Season(
            id: id,
            name: name,
            overview: overview,
            airDate: airDate,
            episodeCount: episodeCount,
            posterPath: posterPath,
            seasonNumber: seasonNumber,
            episodes: episodes?.map { $0.asDomain() }
        )
    }
}
