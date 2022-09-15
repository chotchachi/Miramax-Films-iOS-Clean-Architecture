//
//  DataSourceAssembly.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Swinject

final class DataSourceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(RemoteDataSourceProtocol.self) { resolver in
            guard let apiClient = resolver.resolve(Api.self) else {
                fatalError("Api dependency could not be resolved")
            }
            return RemoteDataSource(apiClient: apiClient)
        }
        container.register(LocalDataSourceProtocol.self) { _ in
            return LocalDataSource()
        }
    }
}
