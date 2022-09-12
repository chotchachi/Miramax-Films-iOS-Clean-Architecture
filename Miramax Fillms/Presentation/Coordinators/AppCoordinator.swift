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
    
    init() {
        super.init(rootViewController: MainNavigationController(), initialRoute: .splash)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .splash:
            let vc = SplashViewController()
            vc.viewModel = SplashViewModel(router: unownedRouter)
            return .set([vc])
        case .home:
            return .set([HomeCoordinator().strongRouter])
        }
    }
}
