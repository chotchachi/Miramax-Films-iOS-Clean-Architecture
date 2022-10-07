//
//  MovieRepository.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

import RxSwift
import Domain

public final class MovieRepository: MovieRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    public init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func getNowPlaying(genreId: Int?, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMovieNowPlaying(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getTopRated(genreId: Int?, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMovieTopRated(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getPopular(genreId: Int?, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMoviePopular(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getUpComing(genreId: Int?, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMovieUpcoming(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getByGenre(genreId: Int, sortOption: SortOption, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMovieByGenre(genreId: genreId, sortBy: sortOption.value, page: page)
            .map { $0.asDomain() }
    }
    
    public func getDetail(movieId: Int) -> Single<MovieDetail> {
        return remoteDataSource
            .getMovieDetail(movieId: movieId)
            .map { $0.asDomain() }
    }
    
    public func getRecommendations(movieId: Int, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .getMovieRecommendations(movieId: movieId, page: page)
            .map { $0.asDomain() }
    }
}
