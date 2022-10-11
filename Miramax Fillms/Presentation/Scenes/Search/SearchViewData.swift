//
//  SearchViewData.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import Domain

enum SearchViewData {
    case recent(items: [EntertainmentViewModel])
    case movie(items: [EntertainmentViewModel], hasNextPage: Bool)
    case tvShow(items: [EntertainmentViewModel], hasNextPage: Bool)
    case actor(items: [PersonViewModel], hasNextPage: Bool)
}
