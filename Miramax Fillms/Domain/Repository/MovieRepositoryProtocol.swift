//
//  MovieRepositoryProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import RxSwift

protocol MovieRepositoryProtocol {
    func getNowPlaying(genreId: Int?, page: Int?) -> Single<MovieResponse>
    func getTopRated(genreId: Int?, page: Int?) -> Single<MovieResponse>
    func getPopular(genreId: Int?, page: Int?) -> Single<MovieResponse>
    func getUpComing(genreId: Int?, page: Int?) -> Single<MovieResponse>
    func getLatest(genreId: Int?, page: Int?) -> Single<MovieResponse>
    func getByGenre(genreId: Int?, page: Int?) -> Single<MovieResponse>
    func getMovieDetail(movieId: Int) -> Single<MovieDetail>
}
