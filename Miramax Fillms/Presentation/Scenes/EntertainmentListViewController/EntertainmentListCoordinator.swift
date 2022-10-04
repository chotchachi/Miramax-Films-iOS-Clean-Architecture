//
//  EntertainmentListCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 27/09/2022.
//

import XCoordinator
import Domain

enum EntertainmentListRoute: Route {
    case initial(type: EntertainmentListType)
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

    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, type: EntertainmentListType) {
        self.appDIContainer = appDIContainer
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(type: type))
    }
    
    override func prepareTransition(for route: EntertainmentListRoute) -> NavigationTransition {
        switch route {
        case .initial(type: let type):
            let vc = EntertainmentListViewController()
            vc.viewModel = EntertainmentListViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, type: type)
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
