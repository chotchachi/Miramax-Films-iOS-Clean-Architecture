//
//  MovieCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import XCoordinator
import Domain

enum MovieRoute: Route {
    case initial
    case search
    case movieDetails(movie: Movie)
    case genreDetails(genre: Genre)
}

class MovieCoordinator: NavigationCoordinator<MovieRoute> {
    
    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(initialRoute: .initial)
        
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepareTransition(for route: MovieRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = MovieViewController()
            vc.viewModel = MovieViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter)
            return .push(vc)
        case .search:
            addChild(SearchCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController))
            return .none()
        case .movieDetails(movie: let movie):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainment: movie))
            return .none()
        case .genreDetails(genre: let genre):
            addChild(GenreDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, genre: genre))
            return .none()
        }
    }
}
