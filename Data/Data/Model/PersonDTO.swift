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
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        profilePath <- map["profile_path"]
    }
}

extension PersonDTO: DomainConvertibleType {
    public func asDomain() -> Person {
        return Person(
            id: id,
            name: name,
            profilePath: profilePath
        )
    }
}
