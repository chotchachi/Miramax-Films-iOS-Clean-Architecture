//
//  EpisodeDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import ObjectMapper

struct EpisodeDTO : Mappable {
    var id: Int!
    var name: String!
    var overview: String!
    var runtime: Int?
    var episodeNumber: Int!
    var seasonNumber: Int!
    var airDate: String!
    var voteAverage: Double!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        overview <- map["overview"]
        runtime <- map["runtime"]
        episodeNumber <- map["episode_number"]
        seasonNumber <- map["season_number"]
        airDate <- map["air_date"]
        voteAverage <- map["vote_average"]
    }
}

extension EpisodeDTO: DomainConvertibleType {
    func asDomain() -> Episode {
        return Episode(id: id, name: name, overview: overview, runtime: runtime, episodeNumber: episodeNumber, seasonNumber: seasonNumber, airDate: airDate, voteAverage: voteAverage)
    }
}
