//
//  RepositoryAssembly.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 14/09/2022.
//

import Swinject

final class RepositoryAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MovieRepositoryProtocol.self) { resolver in
            guard let api = resolver.resolve(Api.self) else {
                fatalError("Api dependency could not be resolved")
            }
            return MovieRepository(api: api)
        }
    }
}
