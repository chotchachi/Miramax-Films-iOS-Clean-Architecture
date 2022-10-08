//
//  SearchCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import XCoordinator
import Domain

enum SearchRoute: Route {
    case initial
    case dismiss
    case entertainmentDetails(entertainment: EntertainmentModelType)
    case personDetails(person: Person)
    case entertainmentList(responseRoute: EntertainmentsResponseRoute)
}

class SearchCoordinator: NavigationCoordinator<SearchRoute> {
    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(initialRoute: .initial)
        
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepareTransition(for route: SearchRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = SearchViewController()
            vc.viewModel = SearchViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter)
            return .push(vc)
        case .dismiss:
            return .dismiss(animation: .fade)
        case .entertainmentDetails(entertainment: let entertainment):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainment: entertainment, fromSearch: true))
            return .none()
        case .personDetails(person: let person):
            addChild(PersonDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, personId: person.id, fromSearch: true))
            return .none()
        case .entertainmentList(responseRoute: let responseRoute):
            addChild(EntertainmentListCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, responseRoute: responseRoute, fromSearch: true))
            return .none()
        }
    }
}
