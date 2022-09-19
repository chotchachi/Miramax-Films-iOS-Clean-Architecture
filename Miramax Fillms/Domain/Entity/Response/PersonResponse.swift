//
//  PersonResponse.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

struct PersonResponse: Equatable {
    let page: Int
    let results: [Person]
    let totalPages: Int
    let totalResults: Int
}
