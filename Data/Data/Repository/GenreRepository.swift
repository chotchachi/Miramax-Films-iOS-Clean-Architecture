//
//  GenreRepository.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift
import Domain

public final class GenreRepository: GenreRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    public init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func getGenreMovieList() -> Single<[Genre]> {
        return remoteDataSource
            .getGenreMovieList()
            .map { $0.asDomain().genres }
            .map { items -> [Genre] in
                items.map { item -> Genre in
                    var item = item
                    item.entertainmentType = .movie
                    return item
                }
            }
    }
    
    public func getGenreShowList() -> Single<[Genre]> {
        return remoteDataSource
            .getGenreShowList()
            .map { $0.asDomain().genres }
            .map { items -> [Genre] in
                items.map { item -> Genre in
                    var item = item
                    item.entertainmentType = .tvShow
                    return item
                }
            }
    }
}
