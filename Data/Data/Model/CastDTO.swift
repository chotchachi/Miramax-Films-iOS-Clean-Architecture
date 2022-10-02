//
//  CastDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import ObjectMapper
import Domain

public struct CastDTO : Mappable {
    public var id: Int = 0
    public var name: String = ""
    public var character: String = ""
    public var profilePath: String?
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        character <- map["character"]
        profilePath <- map["profile_path"]
    }
}

extension CastDTO: DomainConvertibleType {
    public func asDomain() -> Cast {
        return Cast(
            id: id,
            name: name,
            character: character,
            profilePath: profilePath
        )
    }
}
