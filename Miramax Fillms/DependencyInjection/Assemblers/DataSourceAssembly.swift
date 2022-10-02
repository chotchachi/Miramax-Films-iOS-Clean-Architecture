//
//  DataSourceAssembly.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Swinject
import Data

final class DataSourceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(RemoteDataSourceProtocol.self) { resolver in
            return RemoteDataSource(apiClient: resolver.resolve(), apiKey: "9f7ceb7615afe6f16274a953ad31c29e")
        }
        container.register(LocalDataSourceProtocol.self) { _ in
            return LocalDataSource(dbManager: DBManager())
        }
    }
}
