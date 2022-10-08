//
//  PersonCreditDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import ObjectMapper
import Domain

public struct PersonCreditDTO : Mappable {
    public var id: Int = 0
    public var title: String = ""
    public var overview: String = ""
    public var voteAverage: Double = 0
    public var releaseDate: String = ""
    public var firstAirDate: String = ""
    public var mediaType: String = ""
    public var backdropPath: String?
    public var posterPath: String?
    public var character: String? // Cast
    public var job: String? // Crew
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        overview <- map["overview"]
        voteAverage <- map["vote_average"]
        releaseDate <- map["release_date"]
        firstAirDate <- map["first_air_date"]
        mediaType <- map["media_type"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        character <- map["character"]
        job <- map["job"]
    }
}
