//
//  TVShowResponse.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

public struct TVShowResponse: Equatable {
    public let page: Int
    public let results: [TVShow]
    public let totalPages: Int
    public let totalResults: Int
    
    public init(page: Int, results: [TVShow], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
