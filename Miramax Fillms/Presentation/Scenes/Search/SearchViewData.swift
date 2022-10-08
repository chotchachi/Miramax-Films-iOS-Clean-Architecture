//
//  SearchViewData.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import Domain

enum SearchViewData {
    case recent(items: [EntertainmentModelType])
    case movie(items: [EntertainmentModelType], hasNextPage: Bool)
    case tvShow(items: [EntertainmentModelType], hasNextPage: Bool)
    case actor(items: [Person], hasNextPage: Bool)
}
