//
//  GenresCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import XCoordinator

enum GenresRoute: Route {
    case initial
    case search
    case genreDetails(genre: Genre)
}

class GenresCoordinator: NavigationCoordinator<GenresRoute> {
    
    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(initialRoute: .initial)
        
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepareTransition(for route: GenresRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = GenresViewController()
            vc.viewModel = GenresViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter)
            return .push(vc)
        case .search:
            addChild(SearchCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController))
            return .none()
        case .genreDetails(genre: let genre):
            addChild(GenreDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, genre: genre))
            return .none()
        }
    }
}
