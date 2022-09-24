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
    var images: [ImageDTO] = []
    var castCredits: [PersonCreditDTO] = []
    var crewCredits: [PersonCreditDTO] = []

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        birthday <- map["birthday"]
        biography <- map["biography"]
        profilePath <- map["profile_path"]
        images <- map["images.profiles"]
        castCredits <- map["combined_credits.cast"]
        crewCredits <- map["combined_credits.crew"]
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
            images: images.map { $0.asDomain() },
            castCredits: castCredits.map { $0.asDomain() },
            crewCredits: crewCredits.map { $0.asDomain() }
        )
    }
}
