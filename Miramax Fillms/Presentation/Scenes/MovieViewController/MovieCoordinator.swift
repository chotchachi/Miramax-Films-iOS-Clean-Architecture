//
//  MovieCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import XCoordinator
import Domain


enum MovieRoute: Route {
    case initial
    case search
    case entertainmentDetails(entertainment: EntertainmentModelType)
    case entertainmentList(responseRoute: EntertainmentsResponseRoute)
}

class MovieCoordinator: NavigationCoordinator<MovieRoute> {
    
    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(initialRoute: .initial)
        
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepareTransition(for route: MovieRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = MovieViewController()
            vc.viewModel = MovieViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter)
            return .push(vc)
        case .search:
            let searchCoordinator = SearchCoordinator(appDIContainer: appDIContainer)
            return .presentFullScreen(searchCoordinator, animation: .fade)
        case .entertainmentDetails(entertainment: let entertainment):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainment: entertainment))
            return .none()
        case .entertainmentList(responseRoute: let responseRoute):
            addChild(EntertainmentListCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, responseRoute: responseRoute))
            return .none()
        }
    }
}
