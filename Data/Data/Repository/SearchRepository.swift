//
//  SearchRepository.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import RxSwift
import Domain

public final class SearchRepository: SearchRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    public init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func searchMovie(query: String, page: Int?) -> Single<BaseResponse<Movie>> {
        return remoteDataSource
            .searchMovie(query: query, page: page)
            .map { $0.asBaseResponse() }
    }
    
    public func searchTVShow(query: String, page: Int?) -> Single<BaseResponse<TVShow>> {
        return remoteDataSource
            .searchTVShow(query: query, page: page)
            .map { $0.asBaseResponse() }
    }
    
    public func searchPerson(query: String, page: Int?) -> Single<BaseResponse<Person>> {
        return remoteDataSource
            .searchPerson(query: query, page: page)
            .map { $0.asDomain() }
    }
    
    public func getRecentEntertainment() -> Observable<[RecentEntertainment]> {
        return localDataSource
            .getSearchRecentEntertainments()
            .map { items in items.map { $0.asDomain() } }
            .map { items in items.sorted { $0.createAt > $1.createAt } } // sort by createAt
    }
    
    public func addRecentEntertainment(item: RecentEntertainment) -> Observable<Void> {
        return localDataSource
            .saveSearchRecentEntertainments(item: item.asRealm())
    }
    
    public func removeAllRecentEntertainment() -> Observable<Void> {
        return localDataSource
            .removeAllRecentEntertainment()
    }
}
