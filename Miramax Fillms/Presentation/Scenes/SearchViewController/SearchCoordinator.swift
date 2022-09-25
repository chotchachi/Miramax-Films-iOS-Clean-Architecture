//
//  SearchCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import XCoordinator

enum SearchRoute: Route {
    case initial
    case dismiss
    case entertaimentDetails(entertainment: EntertainmentModelType)
    case personDetails(person: PersonModelType)
}

class SearchCoordinator: NavigationCoordinator<SearchRoute> {
    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController) {
        self.appDIContainer = appDIContainer
        super.init(rootViewController: rootViewController, initialRoute: .initial)
    }
    
    override func prepareTransition(for route: SearchRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let vc = SearchViewController()
            vc.viewModel = SearchViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter)
            return .push(vc)
        case .dismiss:
            return .pop(animation: .fade)
        case .entertaimentDetails(entertainment: let entertainment):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainment: entertainment))
            return .none()
        case .personDetails(person: let person):
            addChild(PersonDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, personModel: person))
            return .none()
        }
    }
}
