//
//  SearchViewData.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import Domain

enum SearchViewData {
    case recent(items: [RecentEntertainment])
    case movie(items: [Movie], hasNextPage: Bool)
    case tvShow(items: [TVShow], hasNextPage: Bool)
    case actor(items: [Person], hasNextPage: Bool)
}
