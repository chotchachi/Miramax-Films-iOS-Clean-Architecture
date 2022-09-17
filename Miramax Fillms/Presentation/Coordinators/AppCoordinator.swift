//
//  AppCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import UIKit
import XCoordinator

enum AppRoute: Route {
    case splash
    case home
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(rootViewController: MainNavigationController(), initialRoute: .splash)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .splash:
            return getSplashTransition(for: route)
        case .home:
            return getHomeTransition(for: route)
        }
    }
    
    private func getSplashTransition(for route: AppRoute) -> NavigationTransition {
        let vc = SplashViewController()
        vc.viewModel = SplashViewModel(router: unownedRouter)
        return .set([vc])
    }
    
    private func getHomeTransition(for route: AppRoute) -> NavigationTransition {
        let homeRoute = HomeCoordinator(appDIContainer: appDIContainer).strongRouter
        return .set([homeRoute])
    }
}
