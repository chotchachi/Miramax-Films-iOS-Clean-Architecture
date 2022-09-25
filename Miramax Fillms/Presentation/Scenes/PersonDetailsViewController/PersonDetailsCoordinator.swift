//
//  PersonDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import XCoordinator

enum PersonDetailsRoute: Route {
    case initial(personModel: PersonModelType)
    case pop
    case search
    case biography(personDetail: PersonDetail)
}

class PersonDetailsCoordinator: NavigationCoordinator<PersonDetailsRoute> {
    
    private let appDIContainer: AppDIContainer
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, personModel: PersonModelType) {
        self.appDIContainer = appDIContainer
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(personModel: personModel))
    }
    
    override func prepareTransition(for route: PersonDetailsRoute) -> NavigationTransition {
        switch route {
        case .initial(personModel: let personModel):
            let vc = PersonDetailsViewController()
            vc.viewModel = PersonDetailsViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, personModel: personModel)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        case .search:
            addChild(SearchCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController))
            return .none()
        case .biography(personDetail: let personDetail):
            addChild(PersonBiographyCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController, personDetail: personDetail))
            return .none()
        }
    }
}
