//
//  SelfieMovieCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/10/2022.
//

import XCoordinator
import Domain

enum SelfieMovieRoute: Route {
    case initial
    case dismiss
    case chooseMovie(selfieFrame: SelfieFrame)
}

class SelfieMovieCoordinator: NavigationCoordinator<SelfieMovieRoute> {
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(initialRoute: .initial)
        
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepareTransition(for route: SelfieMovieRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = SelfieMovieViewController()
            vc.viewModel = SelfieMovieViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter)
            return .push(vc)
        case .dismiss:
            return .dismiss(animation: .navigation)
        case .chooseMovie(selfieFrame: let selfieFrame):
            return .none()
        }
    }
}
