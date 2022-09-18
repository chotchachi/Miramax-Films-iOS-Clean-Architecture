//
//  TVShowViewData.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

enum TVShowViewData {
    case genreViewState(viewState: ViewState<Genre>)
    case airingTodayViewState(viewStatte: ViewState<TVShow>)
    case onTheAirViewState(viewState: ViewState<TVShow>)
    case tabSelection
}
