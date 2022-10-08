//
//  PersonResponseDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import ObjectMapper
import Domain

public struct PersonResponseDTO: Mappable {
    public var page: Int = 0
    public var results: [PersonDTO] = []
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

extension PersonResponseDTO: DomainConvertibleType {
    public func asDomain() -> BaseResponse<Person> {
        return BaseResponse(page: page, results: results.map { $0.asDomain() }, totalPages: totalPages, totalResults: totalResults)
    }
}
