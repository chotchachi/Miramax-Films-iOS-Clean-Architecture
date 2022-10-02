//
//  GenreResponseDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import ObjectMapper
import Domain

public struct GenreResponseDTO: Mappable {
    public var genres: [GenreDTO] = []
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        genres <- map["genres"]
    }
}

extension GenreResponseDTO: DomainConvertibleType {
    public func asDomain() -> GenreResponse {
        return GenreResponse(genres: genres.map { $0.asDomain() })
    }
}
