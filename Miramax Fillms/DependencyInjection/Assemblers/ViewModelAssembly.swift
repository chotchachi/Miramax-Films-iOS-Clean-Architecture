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
            guard let movieRepository = resolver.resolve(MovieRepositoryProtocol.self) else {
                fatalError("Api dependency could not be resolved")
            }
            return MovieViewModel(movieRepository: movieRepository)
        }
    }
}
