//
//  EntertainmentsResponseRoute.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 04/10/2022.
//

import Domain

enum EntertainmentsResponseRoute {
    case discover(genre: Genre)
    case recommendations(entertainment: EntertainmentModelType)
    case movieUpcoming
    case movieTopRating
    case movieNowPlaying
    case movieTrending
    case showUpcoming
}
