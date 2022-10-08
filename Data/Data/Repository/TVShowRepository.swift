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
    
    public func getAiringToday(genreId: Int?, page: Int?) -> Single<BaseResponse<TVShow>> {
        return remoteDataSource
            .getTVShowAiringToday(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getOnTheAir(genreId: Int?, page: Int?) -> Single<BaseResponse<TVShow>> {
        return remoteDataSource
            .getTVShowOnTheAir(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getTopRated(genreId: Int?, page: Int?) -> Single<BaseResponse<TVShow>> {
        return remoteDataSource
            .getTVShowTopRated(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getPopular(genreId: Int?, page: Int?) -> Single<BaseResponse<TVShow>> {
        return remoteDataSource
            .getTVShowPopular(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getByGenre(genreId: Int, sortOption: SortOption, page: Int?) -> Single<BaseResponse<TVShow>> {
        return remoteDataSource
            .getTVShowByGenre(genreId: genreId, sortBy: sortOption.value, page: page)
            .map { $0.asDomain() }
    }
    
    public func getDetail(tvShowId: Int) -> Single<TVShow> {
        return remoteDataSource
            .getTVShowDetail(tvShowId: tvShowId)
            .map { $0.asDomain() }
    }
    
    public func getRecommendations(tvShowId: Int, page: Int?) -> Single<BaseResponse<TVShow>> {
        return remoteDataSource
            .getTVShowRecommendations(tvShowId: tvShowId, page: page)
            .map { $0.asDomain() }
    }
    
    public func getSeasonDetails(tvShowId: Int, seasonNumber: Int) -> Single<Season> {
        return remoteDataSource
            .getTVShowSeasonDetails(tvShowId: tvShowId, seasonNumber: seasonNumber)
            .map { $0.asDomain() }
    }
}
