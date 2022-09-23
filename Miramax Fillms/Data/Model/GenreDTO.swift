//
//  GenreDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import ObjectMapper

struct GenreDTO : Mappable {
    var id: Int = 0
    var name: String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

extension GenreDTO: DomainConvertibleType {
    func asDomain() -> Genre {
        return Genre(id: id, name: name)
    }
}
