//
//  MovieRepository.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import RxSwift

final class MovieRepository: MovieRepositoryProtocol {    
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    init(
        remoteDataSource: RemoteDataSourceProtocol,
        localDataSource: LocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getNowPlaying(genreId: Int?, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMovieNowPlaying(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func getTopRated(genreId: Int?, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMovieTopRated(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func getPopular(genreId: Int?, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMoviePopular(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func getUpComing(genreId: Int?, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMovieUpcoming(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func getLatest(genreId: Int?, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMovieLatest(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func getByGenre(genreId: Int?, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMovieByGenre(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func searchMovie(query: String, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .searchMovie(query: query, page: page)
            .map { $0.asDomain() }
    }
}
