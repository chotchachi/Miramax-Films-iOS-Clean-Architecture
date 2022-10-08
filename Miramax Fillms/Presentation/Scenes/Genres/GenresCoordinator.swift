//
//  GenresCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import XCoordinator
import Domain

enum GenresRoute: Route {
    case initial
    case search
    case discover(genre: Genre)
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
            let searchCoordinator = SearchCoordinator(appDIContainer: appDIContainer)
            return .presentFullScreen(searchCoordinator, animation: .fade)
        case .discover(genre: let genre):
            addChild(EntertainmentListCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, responseRoute: .discover(genre: genre)))
            return .none()
        }
    }
}
