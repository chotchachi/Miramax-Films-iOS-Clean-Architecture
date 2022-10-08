//
//  PersonRepository.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import RxSwift
import Domain

public final class PersonRepository: PersonRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    public init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func getPersonDetail(personId: Int) -> Single<Person> {
        return remoteDataSource
            .getPersonDetail(persondId: personId)
            .map { $0.asDomain() }
    }
    
    public func getBookmarkPersons() -> Observable<[BookmarkPerson]> {
        return localDataSource
            .getBookmarkPersons()
            .map { items in items.map { $0.asDomain() } }
    }
    
    public func saveBookmarkPerson(item: BookmarkPerson) -> Observable<Void> {
        return localDataSource
            .saveBookmarkPerson(item: item.asRealm())
    }
    
    public func removeBookmarkPerson(item: BookmarkPerson) -> Observable<Void> {
        return localDataSource
            .removeBookmarkPerson(item: item.asRealm())
    }
    
    public func removeAllBookmarkPerson() -> Observable<Void> {
        return localDataSource
            .removeAllBookmarkPerson()
    }
}
