//
//  MovieResponseDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import ObjectMapper
import Domain

public struct MovieResponseDTO: Mappable {
    public var page: Int = 0
    public var results: [MovieDTO] = []
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

extension MovieResponseDTO: DomainConvertibleType {
    public func asDomain() -> MovieResponse {
        return MovieResponse(
            page: page,
            results: results.map { $0.asDomain() },
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
    
    public func asBaseResponse() -> BaseResponse<Movie> {
        return BaseResponse(page: page, results: results.map { $0.asDomain() }, totalPages: totalPages, totalResults: totalResults)
    }
}
