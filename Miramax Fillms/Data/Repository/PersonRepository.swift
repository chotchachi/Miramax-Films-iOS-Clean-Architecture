//
//  PersonRepository.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import RxSwift

final class PersonRepository: PersonRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    init(
        remoteDataSource: RemoteDataSourceProtocol,
        localDataSource: LocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
}
