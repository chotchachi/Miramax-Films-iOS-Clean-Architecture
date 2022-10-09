//
//  MovieRepositoryProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import RxSwift

public protocol MovieRepositoryProtocol {
    func getNowPlaying(genreId: Int?, page: Int?) -> Single<BaseResponse<Movie>>
    func getTopRated(genreId: Int?, page: Int?) -> Single<BaseResponse<Movie>>
    func getPopular(genreId: Int?, page: Int?) -> Single<BaseResponse<Movie>>
    func getUpComing(genreId: Int?, page: Int?) -> Single<BaseResponse<Movie>>
    func getByGenre(genreId: Int, sortOption: SortOption, page: Int?) -> Single<BaseResponse<Movie>>
    func getDetail(movieId: Int) -> Single<Movie>
    func getRecommendations(movieId: Int, page: Int?) -> Single<BaseResponse<Movie>>
}
