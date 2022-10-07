//
//  MovieRepositoryProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import RxSwift

public protocol MovieRepositoryProtocol {
    func getNowPlaying(genreId: Int?, page: Int?) -> Single<MovieResponse>
    func getTopRated(genreId: Int?, page: Int?) -> Single<MovieResponse>
    func getPopular(genreId: Int?, page: Int?) -> Single<MovieResponse>
    func getUpComing(genreId: Int?, page: Int?) -> Single<MovieResponse>
    func getByGenre(genreId: Int, sortOption: SortOption, page: Int?) -> Single<MovieResponse>
    func getDetail(movieId: Int) -> Single<MovieDetail>
    func getRecommendations(movieId: Int, page: Int?) -> Single<MovieResponse>
}
