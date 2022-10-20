//
//  RepositoryProvider.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Domain

public final class RepositoryProvider: RepositoryProviderProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol

    public init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func genreRepository() -> GenreRepositoryProtocol {
        return GenreRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
    }
    
    public func movieRepository() -> MovieRepositoryProtocol {
        return MovieRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
    }
    
    public func tvShowRepository() -> TVShowRepositoryProtocol {
        return TVShowRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
    }
    
    public func personRepository() -> PersonRepositoryProtocol {
        return PersonRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
    }
    
    public func searchRepository() -> SearchRepositoryProtocol {
        return SearchRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
    }
    
    public func optionsRepository() -> OptionsRepositoryProtocol {
        return OptionsRepository()
    }
    
    public func entertainmentRepository() -> EntertainmentRepositoryProtocol {
        return EntertainmentRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
    }
    
    public func selfieRepository() -> SelfieRepositoryProtocol {
        return SelfieRepository(localDataSource: localDataSource)
    }
}
