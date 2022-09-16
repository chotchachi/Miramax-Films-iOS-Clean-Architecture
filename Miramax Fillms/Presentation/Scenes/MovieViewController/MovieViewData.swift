//
//  MovieViewData.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Foundation

enum MovieViewData {
    case genreViewState(viewState: ViewState<Genre>)
    case upComingViewState(viewState: ViewState<Movie>)
}
