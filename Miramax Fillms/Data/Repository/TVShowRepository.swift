//
//  TVShowRepository.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import RxSwift

final class TVShowRepository: TVShowRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    init(
        remoteDataSource: RemoteDataSourceProtocol,
        localDataSource: LocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getAiringToday(genreId: Int?, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .getTVShowAiringToday(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func getOnTheAir(genreId: Int?, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .getTVShowOnTheAir(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func getTopRated(genreId: Int?, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .getTVShowTopRated(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func getPopular(genreId: Int?, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .getTVShowPopular(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func getLatest(genreId: Int?, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .getTVShowLatest(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func getByGenre(genreId: Int?, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .getTVShowByGenre(genreId: genreId, page: page)
            .map { $0.asDomain() }
    }
    
    func searchTVShow(query: String, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .searchTVShow(query: query, page: page)
            .map { $0.asDomain() }
    }
    
    func getTVShowDetail(tvShowId: Int) -> Single<TVShowDetail> {
        return remoteDataSource
            .getTVShowDetail(tvShowId: tvShowId)
            .map { $0.asDomain() }
    }
    
    func getTVShowSeasonDetails(tvShowId: Int, seasonNumber: Int) -> Single<Season> {
        return remoteDataSource
            .getTVShowSeasonDetails(tvShowId: tvShowId, seasonNumber: seasonNumber)
            .map { $0.asDomain() }
    }
}
