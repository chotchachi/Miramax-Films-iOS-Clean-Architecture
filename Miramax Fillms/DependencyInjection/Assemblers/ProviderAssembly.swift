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
            return RepositoryProvider(remoteDataSource: resolver.resolve(), localDataSource: resolver.resolve())
        }
    }
}
