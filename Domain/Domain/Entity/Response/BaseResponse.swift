//
//  BaseResponse.swift
//  Domain
//
//  Created by Thanh Quang on 08/10/2022.
//

import Foundation

public struct BaseResponse<T>: Equatable where T: Equatable {
    public let page: Int
    public let results: [T]
    public let totalPages: Int
    public let totalResults: Int
    
    public init(page: Int, results: [T], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
    
    public static func emptyResponse() -> BaseResponse {
        return BaseResponse(page: 0, results: [], totalPages: 0, totalResults: 0)
    }
    
    public var hasNextPage: Bool {
        return page < totalPages
    }
}
