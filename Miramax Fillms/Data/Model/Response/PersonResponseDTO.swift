//
//  PersonResponseDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import ObjectMapper

struct PersonResponseDTO: Mappable {
    var page: Int = 0
    var results: [PersonDTO] = []
    var totalPages: Int = 0
    var totalResults: Int = 0
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        page <- map["page"]
        results <- map["results"]
        totalPages <- map["total_pages"]
        totalResults <- map["total_results"]
    }
}

extension PersonResponseDTO: DomainConvertibleType {
    func asDomain() -> PersonResponse {
        return PersonResponse(
            page: page,
            results: results.map { $0.asDomain() },
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}
