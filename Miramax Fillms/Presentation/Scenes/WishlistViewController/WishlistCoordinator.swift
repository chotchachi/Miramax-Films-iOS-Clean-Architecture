//
//  WishlistCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 08/10/2022.
//

import XCoordinator
import Domain

enum WishlistRoute: Route {
    case initial
    case search
}

class WishlistCoordinator: NavigationCoordinator<WishlistRoute> {
    
    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(initialRoute: .initial)
        
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepareTransition(for route: WishlistRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = WishlistViewController()
            vc.viewModel = WishlistViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter)
            return .push(vc)
        case .search:
            let searchCoordinator = SearchCoordinator(appDIContainer: appDIContainer)
            return .presentFullScreen(searchCoordinator, animation: .fade)
        }
    }
}
