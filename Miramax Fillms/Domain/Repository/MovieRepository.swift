//
//  MovieRepository.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import RxSwift

protocol MovieRepository {
    func getGenreList() -> Single<GenreResponse>
    func getNowPlaying() -> Single<MovieResponse>
    func getTopRated() -> Single<MovieResponse>
    func getPopular() -> Single<MovieResponse>
    func getUpComing() -> Single<MovieResponse>
}
