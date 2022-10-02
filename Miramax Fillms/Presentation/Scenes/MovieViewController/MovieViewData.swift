//
//  MovieViewData.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Domain

enum MovieViewData {
    case genreViewState(viewState: ViewState<Genre>)
    case upComingViewState(viewState: ViewState<Movie>)
    case selfieWithMovie
    case tabSelection
}
