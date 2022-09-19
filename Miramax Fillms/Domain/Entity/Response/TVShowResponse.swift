//
//  TVShowResponse.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

struct TVShowResponse: Equatable {
    let page: Int
    let results: [TVShow]
    let totalPages: Int
    let totalResults: Int
}
