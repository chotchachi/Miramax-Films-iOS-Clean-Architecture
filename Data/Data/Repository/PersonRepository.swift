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
    
    public func getPersonDetail(personId: Int) -> Single<PersonDetail> {
        return remoteDataSource
            .getPersonDetail(persondId: personId)
            .map { $0.asDomain() }
    }
}
