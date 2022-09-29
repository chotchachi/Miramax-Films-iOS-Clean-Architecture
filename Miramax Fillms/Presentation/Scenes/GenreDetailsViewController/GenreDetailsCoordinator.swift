//
//  GenreDetailsCoordinator.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 27/09/2022.
//

import XCoordinator

enum GenreDetailsRoute: Route {
    case initial(genre: Genre)
    case pop
    case search
    case entertainmentDetails(entertainment: EntertainmentModelType)
}

class GenreDetailsCoordinator: NavigationCoordinator<GenreDetailsRoute> {
    
    private let appDIContainer: AppDIContainer

    public override var viewController: UIViewController! {
        return autoreleaseController
    }
    
    private weak var autoreleaseController: UIViewController?

    init(appDIContainer: AppDIContainer, rootViewController: UINavigationController, genre: Genre) {
        self.appDIContainer = appDIContainer
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.initial(genre: genre))
    }
    
    override func prepareTransition(for route: GenreDetailsRoute) -> NavigationTransition {
        switch route {
        case .initial(genre: let genre):
            let vc = GenreDetailsViewController()
            vc.viewModel = GenreDetailsViewModel(repositoryProvider: appDIContainer.resolve(), router: unownedRouter, genre: genre)
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
