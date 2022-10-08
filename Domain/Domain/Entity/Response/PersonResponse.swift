//
//  PersonResponse.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

public struct PersonResponse: Equatable {
    public let page: Int
    public let results: [Person]
    public let totalPages: Int
    public let totalResults: Int
    
    public init(page: Int, results: [Person], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
    
    public static let emptyResponse = PersonResponse(page: 0, results: [], totalPages: 0, totalResults: 0)
}
