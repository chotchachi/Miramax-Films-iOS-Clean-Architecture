//
//  SeasonDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 22/09/2022.
//

import XCoordinator
import Domain

enum SeasonDetailsRoute: Route {
    case initial(season: Season)
    case pop
}

class SeasonDetailsCoordinator: NavigationCoordinator<SeasonDetailsRoute> {
    
    private let appDIContainer: AppDIContainer
    private let tvShowId: Int
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, tvShowId: Int, season: Season) {
        self.appDIContainer = appDIContainer
        self.tvShowId = tvShowId
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(season: season))
    }
    
    override func prepareTransition(for route: SeasonDetailsRoute) -> NavigationTransition {
        switch route {
        case .initial(season: let season):
            let vc = SeasonDetailsViewController()
            vc.viewModel = SeasonDetailsViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, tvShowId: tvShowId, season: season)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        }
    }
}
