//
//  PersonDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import ObjectMapper

struct PersonDTO: Mappable {
    var id: Int!
    var name: String!
    var profilePath: String?
    var popularity: Double!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        profilePath <- map["profile_path"]
        popularity <- map["popularity"]
    }
}

extension PersonDTO: DomainConvertibleType {
    func asDomain() -> Person {
        return Person(
            id: id,
            name: name,
            profilePath: profilePath,
            popularity: popularity
        )
    }
}
