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
    case entertainmentDetail(entertainmentId: Int, entertainmentType: EntertainmentType)
    case entertainmentList(responseRoute: EntertainmentsResponseRoute)
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
            let searchCoordinator = SearchCoordinator(appDIContainer: appDIContainer)
            return .presentFullScreen(searchCoordinator, animation: .fade)
        case .entertainmentDetail(entertainmentId: let entertainmentId, entertainmentType: let entertainmentType):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainmentId: entertainmentId, entertainmentType: entertainmentType))
            return .none()
        case .entertainmentList(responseRoute: let responseRoute):
            addChild(EntertainmentListCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, responseRoute: responseRoute))
            return .none()
        }
    }
}
