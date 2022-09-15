//
//  GenreRepository.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift

final class GenreRepository: GenreRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    init(
        remoteDataSource: RemoteDataSourceProtocol,
        localDataSource: LocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getGenreMovieList() -> Single<GenreResponse> {
        return remoteDataSource
            .getGenreMovieList()
            .map { $0.asDomain() }
    }
    
    func getGenreShowList() -> Single<GenreResponse> {
        return remoteDataSource
            .getGenreShowList()
            .map { $0.asDomain() }
    }
}
