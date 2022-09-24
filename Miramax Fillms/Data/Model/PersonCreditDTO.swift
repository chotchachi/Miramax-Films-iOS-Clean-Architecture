//
//  PersonCreditDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import ObjectMapper

struct PersonCreditDTO : Mappable {
    var id: Int = 0
    var title: String = ""
    var posterPath: String?
    var character: String?
    var job: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        posterPath <- map["poster_path"]
        character <- map["character"]
        job <- map["job"]
    }
}

extension PersonCreditDTO: DomainConvertibleType {
    func asDomain() -> PersonCredit {
        return PersonCredit(
            id: id,
            title: title,
            posterPath: posterPath,
            character: character,
            job: job
        )
    }
}
