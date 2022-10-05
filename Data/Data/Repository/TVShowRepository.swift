//
//  TVShowRepository.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import RxSwift
import Domain

public final class TVShowRepository: TVShowRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    public init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func getAiringToday(genreId: Int?, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .getTVShowAiringToday(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getOnTheAir(genreId: Int?, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .getTVShowOnTheAir(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getTopRated(genreId: Int?, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .getTVShowTopRated(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getPopular(genreId: Int?, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .getTVShowPopular(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getByGenre(genreId: Int?, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .getTVShowByGenre(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getTVShowDetail(tvShowId: Int) -> Single<TVShowDetail> {
        return remoteDataSource
            .getTVShowDetail(tvShowId: tvShowId)
            .map { $0.asDomain() }
    }
    
    public func getTVShowSeasonDetails(tvShowId: Int, seasonNumber: Int) -> Single<Season> {
        return remoteDataSource
            .getTVShowSeasonDetails(tvShowId: tvShowId, seasonNumber: seasonNumber)
            .map { $0.asDomain() }
    }
}
