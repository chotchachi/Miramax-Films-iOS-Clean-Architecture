//
//  ViewModelAssembly.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 14/09/2022.
//

import Swinject

final class ViewModelAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MovieViewModel.self) { resolver in
            guard let repositoryProvider = resolver.resolve(RepositoryProviderProtocol.self) else {
                fatalError("RepositoryProvider dependency could not be resolved")
            }
            return MovieViewModel(repositoryProvider: repositoryProvider)
        }
    }
}
