//
//  EntertainmentViewResponse.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 08/10/2022.
//

import Domain

struct EntertainmentViewResponse {
    public let page: Int
    public let results: [EntertainmentModelType]
    public let totalPages: Int
    public let totalResults: Int
}
