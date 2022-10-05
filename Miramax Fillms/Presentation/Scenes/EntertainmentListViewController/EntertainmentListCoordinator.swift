//
//  EntertainmentListCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 27/09/2022.
//

import XCoordinator
import Domain

enum EntertainmentListRoute: Route {
    case initial(responseRoute: EntertainmentsResponseRoute)
    case pop
    case search
    case entertainmentDetails(entertainment: EntertainmentModelType)
}

class EntertainmentListCoordinator: NavigationCoordinator<EntertainmentListRoute> {
    
    private let appDIContainer: AppDIContainer

    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?

    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, responseRoute: EntertainmentsResponseRoute) {
        self.appDIContainer = appDIContainer
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(responseRoute: responseRoute))
    }
    
    override func prepareTransition(for route: EntertainmentListRoute) -> NavigationTransition {
        switch route {
        case .initial(responseRoute: let responseRoute):
            let vc = EntertainmentListViewController()
            vc.viewModel = EntertainmentListViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, responseRoute: responseRoute)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        case .search:
            addChild(SearchCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController))
            return .none()
        case .entertainmentDetails(entertainment: let entertainment):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainment: entertainment))
            return .none()
        }
    }
}
