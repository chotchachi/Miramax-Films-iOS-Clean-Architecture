//
//  TVShowCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import XCoordinator
import Domain

enum TVShowRoute: Route {
    case initial
    case search
    case tvShowDetails(tvShow: TVShow)
    case genreDetails(genre: Genre)
}

class TVShowCoordinator: NavigationCoordinator<TVShowRoute> {
    
    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(initialRoute: .initial)
        
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepareTransition(for route: TVShowRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = TVShowViewController()
            vc.viewModel = TVShowViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter)
            return .push(vc)
        case .search:
            addChild(SearchCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController))
            return .none()
        case .tvShowDetails(tvShow: let tvShow):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainment: tvShow))
            return .none()
        case .genreDetails(genre: let genre):
            addChild(GenreDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, genre: genre))
            return .none()
        }
    }
}
