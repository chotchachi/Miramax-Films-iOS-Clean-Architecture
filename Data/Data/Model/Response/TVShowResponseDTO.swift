//
//  TVShowResponseDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import ObjectMapper
import Domain

public struct TVShowResponseDTO: Mappable {
    public var page: Int = 0
    public var results: [TVShowDTO] = []
    public var totalPages: Int = 0
    public var totalResults: Int = 0
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        page <- map["page"]
        results <- map["results"]
        totalPages <- map["total_pages"]
        totalResults <- map["total_results"]
    }
}

extension TVShowResponseDTO: DomainConvertibleType {
    public func asDomain() -> TVShowResponse {
        return TVShowResponse(
            page: page,
            results: results.map { $0.asDomain() },
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}
