//
//  PersonBiographyCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 25/09/2022.
//

import XCoordinator

enum PersonBiographyRoute: Route {
    case initial(personDetail: PersonDetail)
    case pop
    case search
}

class PersonBiographyCoordinator: NavigationCoordinator<PersonBiographyRoute> {
    
    private let appDIContainer: AppDIContainer
    
    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?
    
    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, personDetail: PersonDetail) {
        self.appDIContainer = appDIContainer
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(personDetail: personDetail))
    }
    
    override func prepareTransition(for route: PersonBiographyRoute) -> NavigationTransition {
        switch route {
        case .initial(personDetail: let personDetail):
            let vc = PersonBiographyViewController()
            vc.viewModel = PersonBiographyViewModel(router: unownedRouter, personDetail: personDetail)
            autoreleaseController = vc
            return .push(vc)
        case .pop:
            return .pop()
        case .search:
            addChild(SearchCoordinator(appDIContainer: appDIContainer, rootViewController: rootViewController))
            return .none()
        }
    }
}
