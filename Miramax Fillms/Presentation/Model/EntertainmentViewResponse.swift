//
//  EntertainmentViewResponse.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 08/10/2022.
//

import Domain

struct EntertainmentViewResponse {
    let page: Int
    let results: [EntertainmentModelType]
    let totalPages: Int
    let totalResults: Int
}
