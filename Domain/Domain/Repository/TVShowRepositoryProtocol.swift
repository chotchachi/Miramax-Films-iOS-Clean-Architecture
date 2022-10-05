//
//  TVShowRepositoryProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import RxSwift

public protocol TVShowRepositoryProtocol {
    func getAiringToday(genreId: Int?, page: Int?) -> Single<TVShowResponse>
    func getOnTheAir(genreId: Int?, page: Int?) -> Single<TVShowResponse>
    func getTopRated(genreId: Int?, page: Int?) -> Single<TVShowResponse>
    func getPopular(genreId: Int?, page: Int?) -> Single<TVShowResponse>
    func getByGenre(genreId: Int, page: Int?) -> Single<TVShowResponse>
    func getDetail(tvShowId: Int) -> Single<TVShowDetail>
    func getRecommendations(tvShowId: Int, page: Int?) -> Single<TVShowResponse>
    func getSeasonDetails(tvShowId: Int, seasonNumber: Int) -> Single<Season>
}
