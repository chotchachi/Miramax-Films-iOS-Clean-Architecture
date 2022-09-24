//
//  PersonDetailDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import ObjectMapper

struct PersonDetailDTO : Mappable {
    var id: Int = 0
    var name: String = ""
    var birthday: String?
    var biography: String = ""
    var profilePath: String?
    var knownForDepartment: String = ""
    var images: [ImageDTO] = []
    var movies: [MovieDTO] = []
    var tvShows: [TVShowDTO] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        birthday <- map["birthday"]
        biography <- map["biography"]
        knownForDepartment <- map["known_for_department"]
        images <- map["images.profiles"]
        movies <- map["movie_credits.cast"]
        tvShows <- map["tv_credits.cast"]
    }
}

extension PersonDetailDTO: DomainConvertibleType {
    func asDomain() -> PersonDetail {
        return PersonDetail(
            id: id,
            name: name,
            birthday: birthday,
            biography: biography,
            profilePath: profilePath,
            knownForDepartment: knownForDepartment,
            images: images.map { $0.asDomain() },
            movies: movies.map { $0.asDomain() },
            tvShows: tvShows.map { $0.asDomain() }
        )
    }
}
