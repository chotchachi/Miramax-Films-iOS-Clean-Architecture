//
//  RepositoryProvider.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Foundation

final class RepositoryProvider: RepositoryProviderProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol

    init(
        remoteDataSource: RemoteDataSourceProtocol,
        localDataSource: LocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func genreRepository() -> GenreRepositoryProtocol {
        return GenreRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
    }
    
    func movieRepository() -> MovieRepositoryProtocol {
        return MovieRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
    }
    
    func personRepository() -> PersonRepositoryProtocol {
        return PersonRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
    }
}
