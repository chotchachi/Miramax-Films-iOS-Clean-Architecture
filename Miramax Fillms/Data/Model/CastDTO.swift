//
//  CastDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import ObjectMapper

struct CastDTO : Mappable {
    var id: Int = 0
    var name: String = ""
    var character: String = ""
    var profilePath: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        character <- map["character"]
        profilePath <- map["profile_path"]
    }
}

extension CastDTO: DomainConvertibleType {
    func asDomain() -> Cast {
        return Cast(
            id: id,
            name: name,
            character: character,
            profilePath: profilePath
        )
    }
}
