//
//  EpisodeDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import ObjectMapper
import Domain

public struct EpisodeDTO : Mappable {
    public var id: Int = 0
    public var name: String = ""
    public var overview: String = ""
    public var stillPath: String?
    public var episodeNumber: Int = 0
    public var seasonNumber: Int = 0
    public var airDate: String = ""
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        overview <- map["overview"]
        stillPath <- map["still_path"]
        episodeNumber <- map["episode_number"]
        seasonNumber <- map["season_number"]
        airDate <- map["air_date"]
    }
}

extension EpisodeDTO: DomainConvertibleType {
    public func asDomain() -> Episode {
        return Episode(
            id: id,
            name: name,
            overview: overview,
            stillPath: stillPath,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            airDate: airDate
        )
    }
}
