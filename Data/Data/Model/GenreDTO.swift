//
//  GenreDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import ObjectMapper
import Domain

public struct GenreDTO : Mappable {
    public var id: Int = 0
    public var name: String = ""
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

extension GenreDTO: DomainConvertibleType {
    public func asDomain() -> Genre {
        return Genre(id: id, name: name)
    }
}
