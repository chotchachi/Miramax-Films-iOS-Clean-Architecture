//
//  SeasonsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 22/09/2022.
//

import XCoordinator

enum SeasonsRoute: Route {
    case initial(seasons: [Season])
    case pop
}

class SeasonsCoordinator: NavigationCoordinator<SeasonsRoute> {
    
    private let appDIContainer: AppDIContainer
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, seasons: [Season]) {
        self.appDIContainer = appDIContainer
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(seasons: seasons))
    }
    
    override func prepareTransition(for route: SeasonsRoute) -> NavigationTransition {
        switch route {
        case .initial(seasons: let seasons):
            let vc = SeasonsViewController()
            vc.viewModel = SeasonsViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, seasons: seasons)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        }
    }
}
