//
//  ProviderAssembly.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Swinject

final class ProviderAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(RepositoryProviderProtocol.self) { resolver in
            guard let remoteDataSource = resolver.resolve(RemoteDataSourceProtocol.self) else {
                fatalError("RemoteDataSource dependency could not be resolved")
            }
            guard let localDataSource = resolver.resolve(LocalDataSourceProtocol.self) else {
                fatalError("LocalDataSource dependency could not be resolved")
            }
            return RepositoryProvider(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
        }
    }
}
