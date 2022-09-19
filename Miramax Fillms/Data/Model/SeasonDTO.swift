//
//  SeasonDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/09/2022.
//

import ObjectMapper

struct SeasonDTO : Mappable {
    var id: Int!
    var name: String!
    var overview: String!
    var airDate: String?
    var episodeCount: Int!
    var posterPath: String?
    var seasonNumber: Int!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        overview <- map["overview"]
        airDate <- map["air_date"]
        episodeCount <- map["episode_count"]
        posterPath <- map["poster_path"]
        seasonNumber <- map["season_number"]
    }
}

extension SeasonDTO: DomainConvertibleType {
    func asDomain() -> Season {
        return Season(id: id, name: name, overview: overview, airDate: airDate, episodeCount: episodeCount, posterPath: posterPath, seasonNumber: seasonNumber)
    }
}
