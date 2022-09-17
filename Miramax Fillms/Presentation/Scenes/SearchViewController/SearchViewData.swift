//
//  SearchViewData.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import Foundation

enum SearchViewData {
    case recent(items: [Movie])
    case movie(items: [Movie])
    case tvShow(items: [Movie])
    case actor
}
