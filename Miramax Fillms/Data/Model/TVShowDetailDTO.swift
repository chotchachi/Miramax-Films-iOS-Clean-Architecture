//
//  TVShowDetailDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/09/2022.
//

import ObjectMapper

struct TVShowDetailDTO : Mappable {
    var id: Int!
    var name: String!
    var backdropPath: String?
    var posterPath: String?
    var genres: [GenreDTO]!
    var overview: String!
    var firstAirDate: String!
    var voteAverage: Double!
    var episodeRuntime: [Int]!
    var numberOfEpisodes: Int!
    var numberOfSeasons: Int!
    var seasons: [SeasonDTO]!
    var credits: CreditDTO?
    var recommendations: TVShowResponseDTO?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        genres <- map["genres"]
        overview <- map["overview"]
        firstAirDate <- map["first_air_date"]
        voteAverage <- map["vote_average"]
        episodeRuntime <- map["episode_run_time"]
        numberOfEpisodes <- map["number_of_episodes"]
        numberOfSeasons <- map["number_of_seasons"]
        seasons <- map["seasons"]
        credits <- map["credits"]
        recommendations <- map["recommendations"]
    }
}

extension TVShowDetailDTO: DomainConvertibleType {
    func asDomain() -> TVShowDetail {
        return TVShowDetail(id: id, name: name, backdropPath: backdropPath, posterPath: posterPath, genres: genres.map { $0.asDomain() }, overview: overview, firstAirDate: firstAirDate, voteAverage: voteAverage, episodeRuntime: episodeRuntime, numberOfEpisodes: numberOfEpisodes, numberOfSeasons: numberOfSeasons, seasons: seasons.map { $0.asDomain() }, credits: credits?.asDomain(), recommendations: recommendations?.asDomain())
    }
}
