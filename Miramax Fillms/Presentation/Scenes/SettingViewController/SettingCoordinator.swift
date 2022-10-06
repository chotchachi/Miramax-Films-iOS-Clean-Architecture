//
//  SettingCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 06/10/2022.
//

import XCoordinator
import Domain

enum SettingRoute: Route {
    case initial
    case search
}

class SettingCoordinator: NavigationCoordinator<SettingRoute> {
    
    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(initialRoute: .initial)
        
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepareTransition(for route: SettingRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = SettingViewController()
            vc.viewModel = SettingViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter)
            return .push(vc)
        case .search:
            addChild(SearchCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController))
            return .none()
        }
    }
}
