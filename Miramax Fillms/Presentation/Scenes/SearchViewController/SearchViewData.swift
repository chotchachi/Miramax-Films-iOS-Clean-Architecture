//
//  SearchViewData.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import Domain

enum SearchViewData {
    case recent(items: [EntertainmentModelType])
    case movie(items: [EntertainmentModelType])
    case tvShow(items: [EntertainmentModelType])
    case actor(items: [PersonModelType])
}
