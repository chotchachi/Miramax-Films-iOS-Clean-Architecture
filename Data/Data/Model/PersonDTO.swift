//
//  PersonDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import ObjectMapper
import Domain

public struct PersonDTO: Mappable {
    public var id: Int = 0
    public var name: String = ""
    public var profilePath: String?
    public var birthday: String?
    public var biography: String?
    public var images: [ImageDTO]?
    public var castCredits: [PersonCreditDTO]?
    public var crewCredits: [PersonCreditDTO]?
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        profilePath <- map["profile_path"]
        birthday <- map["birthday"]
        biography <- map["biography"]
        images <- map["images.profiles"]
        castCredits <- map["combined_credits.cast"]
        crewCredits <- map["combined_credits.crew"]
    }
}

extension PersonDTO: DomainConvertibleType {
    public func asDomain() -> Person {
        return Person(id: id, name: name, profilePath: profilePath, birthday: birthday, biography: biography, images: images?.map { $0.asDomain() }, departments: getDepartments(), castMovies: getMoviesCast(), castTVShows: getTVShowCast())
    }
}

extension PersonDTO {
    private func getDepartments() -> [String] {
        var allJobs: [String] = []
        allJobs.append(contentsOf: crewCredits?.compactMap { $0.job } ?? [])
        if castCredits?.isEmpty == false {
            allJobs.append("Actor")
        }
        return Array(Set(allJobs))
    }
    
    private func getMoviesCast() -> [Movie] {
        let castCredits = castCredits?.filter { $0.mediaType == "movie" }
            .map { item -> Movie in
                return Movie(id: item.id, title: item.title, overview: item.overview, voteAverage: item.voteAverage, releaseDate: item.releaseDate, backdropPath: item.backdropPath, posterPath: item.posterPath, genres: nil, runtime: nil, credits: nil, recommendations: nil)
            }
        return castCredits ?? []
    }
    
    private func getTVShowCast() -> [TVShow] {
        let castCredits = castCredits?.filter { $0.mediaType == "tv" }
            .map { item -> TVShow in
                return TVShow(id: item.id, name: item.title, overview: item.overview, voteAverage: item.voteAverage, firstAirDate: item.firstAirDate, backdropPath: item.backdropPath, posterPath: item.posterPath, genres: nil, numberOfEpisodes: nil, numberOfSeasons: nil, seasons: nil, credits: nil, recommendations: nil)
            }
        return castCredits ?? []
    }
}
