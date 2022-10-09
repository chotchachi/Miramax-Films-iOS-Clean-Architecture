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
    case entertainmentDetail(entertainmentId: Int, entertainmentType: EntertainmentType)
}

class EntertainmentListCoordinator: NavigationCoordinator<EntertainmentListRoute> {
    
    private let appDIContainer: AppDIContainer
    private let fromSearch: Bool

    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?

    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, responseRoute: EntertainmentsResponseRoute, fromSearch: Bool = false) {
        self.appDIContainer = appDIContainer
        self.fromSearch = fromSearch
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
            if fromSearch {
                return .pop()
            } else {
                let searchCoordinator = SearchCoordinator(appDIContainer: appDIContainer)
                return .presentFullScreen(searchCoordinator, animation: .fade)
            }
        case .entertainmentDetail(entertainmentId: let entertainmentId, entertainmentType: let entertainmentType):
            addChild(EntertainmentDetailsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, entertainmentId: entertainmentId, entertainmentType: entertainmentType))
            return .none()
        }
    }
}
