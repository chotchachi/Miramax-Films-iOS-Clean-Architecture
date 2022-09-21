//
//  SearchRepository.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import RxSwift

final class SearchRepository: SearchRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    init(
        remoteDataSource: RemoteDataSourceProtocol,
        localDataSource: LocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func searchMovie(query: String, page: Int?) -> Single<MovieResponse> {
        return remoteDataSource
            .searchMovie(query: query, page: page)
            .map { $0.asDomain() }
    }
    
    func searchTVShow(query: String, page: Int?) -> Single<TVShowResponse> {
        return remoteDataSource
            .searchTVShow(query: query, page: page)
            .map { $0.asDomain() }
    }
    
    func searchPerson(query: String, page: Int?) -> Single<PersonResponse> {
        return remoteDataSource
            .searchPerson(query: query, page: page)
            .map { $0.asDomain() }
    }
}
