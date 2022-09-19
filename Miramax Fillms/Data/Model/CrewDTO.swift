//
//  CrewDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import ObjectMapper

struct CrewDTO : Mappable {
    var id: Int!
    var name: String!
    var job: String!
    var profilePath: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        job <- map["job"]
        profilePath <- map["profile_path"]
    }
}

extension CrewDTO: DomainConvertibleType {
    func asDomain() -> Crew {
        return Crew(id: id, name: name, job: job, profilePath: profilePath)
    }
}

