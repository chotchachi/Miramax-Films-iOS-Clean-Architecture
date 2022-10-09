//
//  TVShowRepositoryProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import RxSwift

public protocol TVShowRepositoryProtocol {
    func getAiringToday(genreId: Int?, page: Int?) -> Single<BaseResponse<TVShow>>
    func getOnTheAir(genreId: Int?, page: Int?) -> Single<BaseResponse<TVShow>>
    func getTopRated(genreId: Int?, page: Int?) -> Single<BaseResponse<TVShow>>
    func getPopular(genreId: Int?, page: Int?) -> Single<BaseResponse<TVShow>>
    func getByGenre(genreId: Int, sortOption: SortOption, page: Int?) -> Single<BaseResponse<TVShow>>
    func getDetail(tvShowId: Int) -> Single<TVShow>
    func getRecommendations(tvShowId: Int, page: Int?) -> Single<BaseResponse<TVShow>>
    func getSeasonDetails(tvShowId: Int, seasonNumber: Int) -> Single<Season>
    func getBookmarkTVShows() -> Observable<[BookmarkEntertainment]>
    func saveBookmarkTVShow(item: BookmarkEntertainment) -> Observable<Void>
    func removeBookmarkTVShow(item: BookmarkEntertainment) -> Observable<Void>
    func removeAllBookmarkTVShow() -> Observable<Void>
}
