//
//  EpisodeDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import ObjectMapper

struct EpisodeDTO : Mappable {
    var id: Int = 0
    var name: String = ""
    var overview: String = ""
    var episodeNumber: Int = 0
    var seasonNumber: Int = 0
    var airDate: String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        overview <- map["overview"]
        episodeNumber <- map["episode_number"]
        seasonNumber <- map["season_number"]
        airDate <- map["air_date"]
    }
}

extension EpisodeDTO: DomainConvertibleType {
    func asDomain() -> Episode {
        return Episode(
            id: id,
            name: name,
            overview: overview,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            airDate: airDate
        )
    }
}
