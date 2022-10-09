//
//  SeasonDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 22/09/2022.
//

import XCoordinator
import Domain

enum SeasonDetailsRoute: Route {
    case initial
    case pop
}

class SeasonDetailsCoordinator: NavigationCoordinator<SeasonDetailsRoute> {
    
    private let appDIContainer: AppDIContainer
    private let tvShowId: Int
    private let seasonNumber: Int
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, tvShowId: Int, seasonNumber: Int) {
        self.appDIContainer = appDIContainer
        self.tvShowId = tvShowId
        self.seasonNumber = seasonNumber
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial)
    }
    
    override func prepareTransition(for route: SeasonDetailsRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = SeasonDetailsViewController()
            vc.viewModel = SeasonDetailsViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, tvShowId: tvShowId, seasonNumber: seasonNumber)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        }
    }
}
