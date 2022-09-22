//
//  EntertainmentDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import XCoordinator

enum EntertainmentDetailsRoute: Route {
    case initial(entertainment: EntertainmentModelType)
    case pop
    case seasonsList(seasons: [Season])
}

class EntertainmentDetailsCoordinator: NavigationCoordinator<EntertainmentDetailsRoute> {
    
    private let appDIContainer: AppDIContainer
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, entertainment: EntertainmentModelType) {
        self.appDIContainer = appDIContainer
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(entertainment: entertainment))
    }
    
    override func prepareTransition(for route: EntertainmentDetailsRoute) -> NavigationTransition {
        switch route {
        case .initial(entertainment: let entertainment):
            let vc = EntertainmentDetailsViewController()
            vc.viewModel = EntertainmentDetailsViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, entertainmentModel: entertainment)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        case .seasonsList(seasons: let seasons):
            addChild(SeasonsCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, seasons: seasons))
            return .none()
        }
    }
}
