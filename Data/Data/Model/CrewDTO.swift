//
//  CrewDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import ObjectMapper
import Domain

public struct CrewDTO : Mappable {
    public var id: Int = 0
    public var name: String = ""
    public var profilePath: String?
    public var job: String = ""

    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        profilePath <- map["profile_path"]
        job <- map["job"]
    }
}

extension CrewDTO: DomainConvertibleType {
    public func asDomain() -> Crew {
        return Crew(
            id: id,
            name: name,
            profilePath: profilePath,
            job: job
        )
    }
}

