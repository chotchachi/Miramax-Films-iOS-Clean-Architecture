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
            return RemoteDataSource(apiClient: resolver.resolve())
        }
        container.register(LocalDataSourceProtocol.self) { _ in
            return LocalDataSource(dbManager: DBManager())
        }
    }
}
