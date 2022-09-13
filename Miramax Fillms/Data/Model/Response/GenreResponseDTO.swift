//
//  GenreResponseDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import ObjectMapper

struct GenreResponseDTO: Mappable {
    var genres: [GenreDTO] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        genres <- map["genres"]
    }
}

extension GenreResponseDTO: DomainConvertibleType {
    func asDomain() -> GenreResponse {
        return GenreResponse(genres: genres.map { $0.asDomain() })
    }
}
