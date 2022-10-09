//
//  EntertainmentRepository.swift
//  Data
//
//  Created by Thanh Quang on 09/10/2022.
//

import RxSwift
import Domain

public final class EntertainmentRepository: EntertainmentRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    public init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func getAllBookmarkEntertainment() -> Observable<[BookmarkEntertainment]> {
        return localDataSource
            .getBookmarkEntertainments()
            .map { items in items.map { $0.asDomain() } }
    }
    
    public func getAllBookmarkEntertainmentMovie() -> Observable<[BookmarkEntertainment]> {
        return localDataSource
            .getBookmarkEntertainments()
            .map { items in items.filter { $0.type == .movie } }
            .map { items in items.map { $0.asDomain() } }
    }
    
    public func getAllBookmarkEntertainmentTVShow() -> Observable<[BookmarkEntertainment]> {
        return localDataSource
            .getBookmarkEntertainments()
            .map { items in items.filter { $0.type == .tvShow } }
            .map { items in items.map { $0.asDomain() } }
    }
    
    public func saveBookmarkEntertainment(item: BookmarkEntertainment) -> Observable<Void> {
        return localDataSource
            .saveBookmarkEntertainment(item: item.asRealm())
    }
    
    public func removeBookmarkEntertainment(item: BookmarkEntertainment) -> Observable<Void> {
        return localDataSource
            .removeBookmarkEntertainment(item: item.asRealm())
    }
    
    public func removeAllBookmarkEntertainmentMovie() -> Observable<Void> {
        return localDataSource
            .removeAllBookmarkEntertainmentMovie()
    }
    
    public func removeAllBookmarkEntertainmentTVShow() -> Observable<Void> {
        return localDataSource
            .removeAllBookmarkEntertainmentTVShow()
    }
}
